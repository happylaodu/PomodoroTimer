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

class PomodoroTimer: ObservableObject {
    enum State: String, Codable {
            case work, rest, stopped
    }


    @Published var timeRemaining: Int = 25 * 60
    @Published var state: State = .stopped
    @Published var isPaused: Bool = false
    @Published var dailyWorkSessions: Int = 0
    @Published var totalWorkSessions: Int = 0
    
    var onUpdateUI: (() -> Void)?

    private var timer: Timer?
    
    private let userDefaultsKey = "PomodoroState"
    private let dailyWorkKey = "dailyWorkSessions"
    private let totalWorkKey = "totalWorkSessions"
    private let lastWorkDateKey = "lastWorkDate"

    init() {
        restoreState()
        let today = formattedDate(Date())
        let lastDate = UserDefaults.standard.string(forKey: lastWorkDateKey)
        dailyWorkSessions = UserDefaults.standard.integer(forKey: dailyWorkKey)
        totalWorkSessions = UserDefaults.standard.integer(forKey: totalWorkKey)

        if lastDate != today {
            dailyWorkSessions = 0
            UserDefaults.standard.set(today, forKey: lastWorkDateKey)
            UserDefaults.standard.set(dailyWorkSessions, forKey: dailyWorkKey)
        }
        
    }
    
    var isRunning: Bool {
        return timer != nil
    }
    
    func start() {
        guard timer == nil else { return }
        if state == .stopped {
            timeRemaining = 25 * 60
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
        timeRemaining = 25 * 60
        state = .stopped
        clearSavedState()
        
        onUpdateUI?()
    }
    
    func toggleCurrentPhase() {
        timer?.invalidate()

        // 切换状态
        state = (state == .rest) ? .work : .rest
        timeRemaining = state == .work ? 25 * 60 : 5 * 60
        onUpdateUI?()
    }

    private func tick() {
        guard timeRemaining > 0 else {
            if state == .work {
                incrementWorkCounters()
            }
            timer?.invalidate()
            timer = nil
            state = state == .work ? .rest : .work
            timeRemaining = state == .work ? 25 * 60 : 5 * 60
            sendNotification(for: state)
                    
            saveState()
            onUpdateUI?()
            return
        }
        timeRemaining -= 1
        saveState()
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

    private func restoreState() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let saved = try? JSONDecoder().decode(SavedState.self, from: data) else { return }

        if saved.wasRunning {
            let elapsed = Int(Date().timeIntervalSince(saved.timestamp))
            let newRemaining = saved.timeRemaining - elapsed
            if newRemaining > 0 {
                state = saved.state
                timeRemaining = newRemaining
                // Optionally allow auto-resume
            } else {
                state = saved.state == .work ? .rest : .work
                timeRemaining = state == .work ? 25 * 60 : 5 * 60
            }
        } else {
            state = saved.state
            timeRemaining = saved.timeRemaining
        }
    }

    private func clearSavedState() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
    
    private func playSound(repeat count: Int = 3) {
        guard let sound = NSSound(named: NSSound.Name("Ping")) else { return }

            for i in 0..<count {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.5) {
                    sound.stop() // 停止上一次播放，确保声音不会重叠太严重
                    sound.play()
                }
            }
    }
    
    private func sendNotification(for newState: State) {
        let content = UNMutableNotificationContent()
        content.title = "🍅 Pomodoro Session Ended"
        content.body = newState == .work ? "Rest is over. Time to focus!" : "Work completed. Take a break!"
        content.sound = UNNotificationSound.default
        
        playSound(repeat: 3)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to send notification: \(error.localizedDescription)")
            }
        }
    }
    
    private func incrementWorkCounters() {
        let today = formattedDate(Date())
        let lastDate = UserDefaults.standard.string(forKey: lastWorkDateKey)

        if lastDate != today {
            dailyWorkSessions = 0
        }

        dailyWorkSessions += 1
        totalWorkSessions += 1

        UserDefaults.standard.set(today, forKey: lastWorkDateKey)
        UserDefaults.standard.set(dailyWorkSessions, forKey: dailyWorkKey)
        UserDefaults.standard.set(totalWorkSessions, forKey: totalWorkKey)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: date)
    }
}
