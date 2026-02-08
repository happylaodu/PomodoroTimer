//
//  PomodoroTimer.swift
//  PomodoroTimer
//
//  Created by Steven Du on 2025-07-11.
//

import UserNotifications
import Foundation
import Combine

import AppKit
import SwiftUI

class PomodoroTimer: ObservableObject {
    enum State: String, Codable {
            case work, rest, stopped
    }

    @AppStorage("workDuration") var workDuration: Int = 25
    @AppStorage("shortRestDuration") private var shortRestDuration: Int = 5
    @AppStorage("longRestDuration") private var longRestDuration: Int = 15
    @AppStorage("roundsBeforeLongRest") private var roundsBeforeLongRest: Int = 4
    @AppStorage("autoStartWork") private var autoStartWork: Bool = false
    @AppStorage("autoStartRest") private var autoStartRest: Bool = false
    @AppStorage("autoStartNextCycle") private var autoStartNextCycle: Bool = false

    @Published var timeRemaining: Int = 0
    @Published var state: State = .stopped
    @Published var isPaused: Bool = false
    @Published var dailyWorkSessions: Int = 0
    @Published var weeklyWorkSessions: Int = 0
    @Published var totalWorkSessions: Int = 0
    @Published var dailyHistory: [String: Int] = [:]
    @Published var completedRounds: Int = 0
    
    var onUpdateUI: (() -> Void)?
    
    private var defaultsCancellable: AnyCancellable? = nil

    private var timer: Timer?
    
    private let userDefaultsKey = "PomodoroState"
    private let dailyWorkKey = "dailyWorkSessions"
    private let weeklyWorkKey = "weeklyWorkSessions"
    private let totalWorkKey = "totalWorkSessions"
    private let lastWorkDateKey = "lastWorkDate"
    private let lastWeeklyWorkDateKey = "lastWeeklyWorkDate"
    private let historyKey = "dailyHistory"
    private let completedRoundsKey = "completedRounds"

    init() {
        dailyWorkSessions = UserDefaults.standard.integer(forKey: dailyWorkKey)
        weeklyWorkSessions = UserDefaults.standard.integer(forKey: weeklyWorkKey)
        totalWorkSessions = UserDefaults.standard.integer(forKey: totalWorkKey)
        completedRounds = UserDefaults.standard.integer(forKey: completedRoundsKey)

        if let data = UserDefaults.standard.data(forKey: historyKey),
           let history = try? JSONDecoder().decode([String: Int].self, from: data) {
            dailyHistory = history
        }

        // Check date change on initialization
        let isNewDay = checkDateChange()

        // Restore state only if not a new day or autoStartWork is disabled
        if !isNewDay || !autoStartWork {
            restoreState()
        } else {
            // New day with autoStartWork enabled: reset to work state
            state = .work
            timeRemaining = workDuration * 60
            clearSavedState()
        }

        // Monitor settings changes separately from state saves
        defaultsCancellable = NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification)
            .sink { [weak self] _ in
                guard let self = self else { return }
                // Only update timeRemaining if we're in stopped state (not paused with remaining time)
                // This prevents the bug where pausing resets the timer
                if self.state == .stopped {
                    self.timeRemaining = self.workDuration * 60
                    self.onUpdateUI?()
                }
                // Note: For paused state, we intentionally don't update timeRemaining here
                // to preserve the current countdown position
            }

        // Listen for app activation to check date changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAppActivation),
            name: NSApplication.didBecomeActiveNotification,
            object: nil
        )

        // Auto-start work on new day if enabled
        if isNewDay && autoStartWork {
            start()
        }
    }
    
    var isRunning: Bool {
        return timer != nil
    }

    // Check if date has changed and reset daily counters if needed
    @discardableResult
    func checkDateChange() -> Bool {
        let today = formattedDate(Date())
        let lastDate = UserDefaults.standard.string(forKey: lastWorkDateKey)
        let isNewDay = (lastDate != today)

        if isNewDay {
            dailyWorkSessions = 0
            completedRounds = 0
            UserDefaults.standard.set(today, forKey: lastWorkDateKey)
            UserDefaults.standard.set(dailyWorkSessions, forKey: dailyWorkKey)
            UserDefaults.standard.set(completedRounds, forKey: completedRoundsKey)
        }

        // Check week change
        if let lastDateStr = UserDefaults.standard.string(forKey: lastWorkDateKey),
           let lastDate = dateFromFormattedString(lastDateStr),
           !Calendar.current.isDate(Date(), equalTo: lastDate, toGranularity: .weekOfYear) {
            weeklyWorkSessions = 0
            UserDefaults.standard.set(weeklyWorkSessions, forKey: weeklyWorkKey)
        }

        return isNewDay
    }

    @objc private func handleAppActivation() {
        let isNewDay = checkDateChange()
        if isNewDay {
            onUpdateUI?()
        }
    }
    
    func start() {
        guard timer == nil else { return }
        if state == .stopped {
            timeRemaining = workDuration * 60
            state = .work
        }

        timer?.invalidate() // 避免重复定时器
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {[weak self] _ in
            self?.tick()
        }
        isPaused = false
        saveState()
        onUpdateUI?()
    }

    func pause() {
        timer?.invalidate()
        timer = nil
        isPaused = true
        saveState()
    }

    func reset() {
        timer?.invalidate()
        timer = nil
        timeRemaining = workDuration * 60
        state = .stopped
        clearSavedState()
        
        onUpdateUI?()
    }
    
    func toggleCurrentPhase() {
        timer?.invalidate()

        // 切换状态
        if state == .rest {
            state = .work
            timeRemaining = workDuration * 60
        } else {
            // Determine if this rest should be long or short
            completedRounds += 1
            UserDefaults.standard.set(completedRounds, forKey: completedRoundsKey)
            if completedRounds % roundsBeforeLongRest == 0 {
                timeRemaining = longRestDuration * 60
            } else {
                timeRemaining = shortRestDuration * 60
            }
            state = .rest
        }
        onUpdateUI?()
    }

    private func tick() {
        guard timeRemaining > 0 else {
            let previousState = state
            if state == .work {
                incrementWorkCounters()
            }
            timer?.invalidate()
            timer = nil
            if state == .work {
                completedRounds += 1
                UserDefaults.standard.set(completedRounds, forKey: completedRoundsKey)
                state = .rest
                if completedRounds % roundsBeforeLongRest == 0 {
                    timeRemaining = longRestDuration * 60
                } else {
                    timeRemaining = shortRestDuration * 60
                }
            } else {
                state = .work
                timeRemaining = workDuration * 60
            }
            sendNotification(for: state)

            saveState()
            onUpdateUI?()

            // Auto-start next phase if enabled
            if previousState == .work && autoStartRest {
                start()
            } else if previousState == .rest && autoStartNextCycle {
                start()
            }
            return
        }
        timeRemaining -= 1
        saveState()
        onUpdateUI?()
    }
    
    private struct SavedState: Codable {
        var state: State
        var timeRemaining: Int
        var timestamp: Date
        var wasRunning: Bool
    }

    private func saveState() {
        guard state != .stopped else { return }
        let saved = SavedState(
            state: state,
            timeRemaining: timeRemaining,
            timestamp: Date(),
            wasRunning: isRunning
        )
        if let data = try? JSONEncoder().encode(saved) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }

    @discardableResult
    private func restoreState() -> Bool {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let saved = try? JSONDecoder().decode(SavedState.self, from: data) else {
            // No saved state found - initialize to default
            state = .stopped
            timeRemaining = workDuration * 60
            return false
        }

        if saved.wasRunning {
            let elapsed = Int(Date().timeIntervalSince(saved.timestamp))
            let newRemaining = saved.timeRemaining - elapsed
            if newRemaining > 0 {
                state = saved.state
                timeRemaining = newRemaining
                // Optionally allow auto-resume
            } else {
                if saved.state == .work {
                    completedRounds += 1
                    UserDefaults.standard.set(completedRounds, forKey: completedRoundsKey)
                    state = .rest
                    if completedRounds % roundsBeforeLongRest == 0 {
                        timeRemaining = longRestDuration * 60
                    } else {
                        timeRemaining = shortRestDuration * 60
                    }
                } else {
                    state = .work
                    timeRemaining = workDuration * 60
                }
            }
        } else {
            // Restore paused state: use saved timeRemaining to preserve countdown position
            state = saved.state
            timeRemaining = saved.timeRemaining
        }
        return true
    }

    private func clearSavedState() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
    
    private func playSound(repeat count: Int = 3) {
        // Check if sound is enabled (default to true if not set)
        let soundEnabled = UserDefaults.standard.object(forKey: "soundEnabled") as? Bool ?? true
        guard soundEnabled else { return }

        // Get selected sound name
        let soundName = UserDefaults.standard.string(forKey: "notificationSound") ?? "Ping"
        guard let sound = NSSound(named: NSSound.Name(soundName)) else { return }

        for i in 0..<count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.5) {
                sound.stop() // Stop previous playback to avoid severe overlapping
                sound.play()
            }
        }
    }
    
    private func sendNotification(for newState: State) {
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("🍅 Pomodoro Session Ended", comment: "Notification title")
        content.body = newState == .work ? NSLocalizedString("Rest is over. Time to focus!", comment: "Notification body") : NSLocalizedString("Work completed. Take a break!", comment: "Notification body")

        // Only add sound to notification if sound is enabled (default to true if not set)
        let soundEnabled = UserDefaults.standard.object(forKey: "soundEnabled") as? Bool ?? true
        if soundEnabled {
            content.sound = UNNotificationSound.default
        }

        playSound(repeat: 3)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to send notification: \(error.localizedDescription)")
            }
        }
    }
    
    func incrementWorkCounters() {
        let today = formattedDate(Date())
        let lastDate = UserDefaults.standard.string(forKey: lastWorkDateKey)

        if lastDate != today {
            dailyWorkSessions = 0
            completedRounds = 0
            UserDefaults.standard.set(completedRounds, forKey: completedRoundsKey)
        }

        let lastWeeklyDate = UserDefaults.standard.string(forKey: lastWeeklyWorkDateKey)
        if let lastWeekDateStr = lastWeeklyDate,
           let lastWeekDate = dateFromFormattedString(lastWeekDateStr),
           !Calendar.current.isDate(Date(), equalTo: lastWeekDate, toGranularity: .weekOfYear) {
            weeklyWorkSessions = 0
        }

        dailyWorkSessions += 1
        weeklyWorkSessions += 1
        totalWorkSessions += 1

        dailyHistory[today, default: 0] += 1
        if let data = try? JSONEncoder().encode(dailyHistory) {
            UserDefaults.standard.set(data, forKey: historyKey)
        }

        UserDefaults.standard.set(today, forKey: lastWorkDateKey)
        UserDefaults.standard.set(dailyWorkSessions, forKey: dailyWorkKey)
        UserDefaults.standard.set(formattedDate(Date()), forKey: lastWeeklyWorkDateKey)
        UserDefaults.standard.set(weeklyWorkSessions, forKey: weeklyWorkKey)
        UserDefaults.standard.set(totalWorkSessions, forKey: totalWorkKey)
    }
    
    func lastNDaysHistory(_ n: Int) -> [(String, Int)] {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        
        var result: [(String, Int)] = []
        for offset in (0..<n).reversed() {
            if let date = calendar.date(byAdding: .day, value: -offset, to: Date()) {
                let dateString = formatter.string(from: date)
                let count = dailyHistory[dateString, default: 0]
                result.append((dateString, count))
            }
        }
        return result
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: date)
    }
    
    private func dateFromFormattedString(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        return formatter.date(from: string)
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    var isLongRest: Bool {
        roundsBeforeLongRest > 0 && (completedRounds % roundsBeforeLongRest == 0)
    }

    var currentRestDuration: Int {
        isLongRest ? longRestDuration : shortRestDuration
    }

    // MARK: - Keyboard Shortcut Support

    /// Switch to work mode (used by keyboard shortcuts)
    func switchToWork() {
        let wasRunning = isRunning
        if wasRunning {
            pause()
        }

        state = .work
        timeRemaining = workDuration * 60
        saveState()
        onUpdateUI?()

        if wasRunning {
            start()
        }
    }

    /// Switch to rest mode (used by keyboard shortcuts)
    func switchToRest() {
        let wasRunning = isRunning
        if wasRunning {
            pause()
        }

        state = .rest
        // Use same logic as tick() to determine rest duration
        if completedRounds % roundsBeforeLongRest == 0 {
            timeRemaining = longRestDuration * 60
        } else {
            timeRemaining = shortRestDuration * 60
        }
        saveState()
        onUpdateUI?()

        if wasRunning {
            start()
        }
    }
}

