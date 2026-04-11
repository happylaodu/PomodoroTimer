//
//  AchievementManager.swift
//  PomodoroTimer
//
//  Created by Steven Du on 2026-03-11.
//

import Foundation
import SwiftUI
import UserNotifications

class AchievementManager: ObservableObject {
    static let shared = AchievementManager()

    @Published var achievements: [Achievement] = []
    @Published var newlyUnlockedAchievements: [Achievement] = []

    private let achievementsKey = "unlockedAchievements"
    private let currentStreakKey = "currentStreak"
    private let migrationCompleteKey = "achievementMigrationComplete_v5"

    private init() {
        loadAchievements()
        migrateExistingData()

        // Recalculate current streak on initialization
        updateCurrentStreak()
    }

    /// Load achievements from UserDefaults
    private func loadAchievements() {
        // Initialize all achievement types
        var allAchievements = AchievementType.allCases.map { $0.achievement }

        // Load unlocked status from UserDefaults
        if let data = UserDefaults.standard.data(forKey: achievementsKey),
           let unlocked = try? JSONDecoder().decode([String: Date].self, from: data) {
            for i in 0..<allAchievements.count {
                if let unlockedDate = unlocked[allAchievements[i].id] {
                    allAchievements[i].isUnlocked = true
                    allAchievements[i].unlockedDate = unlockedDate
                }
            }
        }

        achievements = allAchievements
    }

    /// One-time migration: Check existing session count and unlock appropriate achievements
    private func migrateExistingData() {
        // Only run once
        guard !UserDefaults.standard.bool(forKey: migrationCompleteKey) else { return }

        // Clear old achievement data to force recalculation with correct dates
        UserDefaults.standard.removeObject(forKey: achievementsKey)

        // Reset all achievements to unlocked state
        for i in 0..<achievements.count {
            achievements[i].isUnlocked = false
            achievements[i].unlockedDate = nil
        }

        // Check historical data from dailyHistory
        if let data = UserDefaults.standard.data(forKey: "dailyHistory"),
           let history = try? JSONDecoder().decode([String: Int].self, from: data) {

            // Migrate session-based achievements with actual dates
            migrateSessionAchievements(from: history)

            // Migrate streak-based achievements with actual dates
            migrateStreakAchievements(from: history)

            // Calculate and set current streak from history to today
            let actualCurrentStreak = calculateCurrentStreak(from: history)
            if actualCurrentStreak > 0 {
                UserDefaults.standard.set(actualCurrentStreak, forKey: currentStreakKey)
            }
        }

        // Mark migration as complete
        UserDefaults.standard.set(true, forKey: migrationCompleteKey)
    }

    /// Migrate session-based achievements with actual unlock dates
    private func migrateSessionAchievements(from history: [String: Int]) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US_POSIX")

        // Get sorted dates (oldest first)
        let sortedDates = history
            .filter { $0.value > 0 }
            .keys
            .compactMap { formatter.date(from: $0) }
            .sorted()

        // Calculate cumulative sessions and find unlock dates
        var cumulativeSessions = 0
        var milestoneUnlockDates: [Int: Date] = [:]  // milestone -> unlock date

        for date in sortedDates {
            let dateString = formatter.string(from: date)
            let sessions = history[dateString] ?? 0
            cumulativeSessions += sessions

            // Check each milestone
            let milestones = [1, 10, 50, 100, 500, 1000]
            for milestone in milestones {
                if cumulativeSessions >= milestone && milestoneUnlockDates[milestone] == nil {
                    milestoneUnlockDates[milestone] = date
                }
            }
        }

        // Unlock achievements with calculated dates
        let sessionAchievements = [
            (AchievementType.firstSession, 1),
            (AchievementType.sessions10, 10),
            (AchievementType.sessions50, 50),
            (AchievementType.sessions100, 100),
            (AchievementType.sessions500, 500),
            (AchievementType.sessions1000, 1000)
        ]

        for (type, milestone) in sessionAchievements {
            if let index = achievements.firstIndex(where: { $0.id == type.rawValue }),
               !achievements[index].isUnlocked,
               let unlockDate = milestoneUnlockDates[milestone] {
                unlockAchievement(at: index, date: unlockDate)
            }
        }
    }

    /// Migrate streak-based achievements with actual unlock dates
    private func migrateStreakAchievements(from history: [String: Int]) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US_POSIX")

        // Get sorted dates (oldest first)
        let dates = history
            .filter { $0.value > 0 }
            .keys
            .compactMap { formatter.date(from: $0) }
            .map { Calendar.current.startOfDay(for: $0) }
            .sorted()

        guard !dates.isEmpty else { return }

        // Track streak and find first achievement dates
        var currentStreak = 1
        var milestoneUnlockDates: [Int: Date] = [:]  // milestone -> first unlock date

        for i in 1..<dates.count {
            let previousDate = dates[i - 1]
            let currentDate = dates[i]
            let daysBetween = Calendar.current.dateComponents([.day], from: previousDate, to: currentDate).day ?? 0

            if daysBetween == 1 {
                currentStreak += 1

                // Check milestones
                let milestones = [7, 30, 100]
                for milestone in milestones {
                    if currentStreak == milestone && milestoneUnlockDates[milestone] == nil {
                        milestoneUnlockDates[milestone] = currentDate
                    }
                }
            } else {
                currentStreak = 1
            }
        }

        // Unlock achievements with calculated dates
        let streakAchievements = [
            (AchievementType.streak7, 7),
            (AchievementType.streak30, 30),
            (AchievementType.streak100, 100)
        ]

        for (type, milestone) in streakAchievements {
            if let index = achievements.firstIndex(where: { $0.id == type.rawValue }),
               !achievements[index].isUnlocked,
               let unlockDate = milestoneUnlockDates[milestone] {
                unlockAchievement(at: index, date: unlockDate)
            }
        }
    }

    /// Calculate longest consecutive streak from historical data
    private func calculateLongestStreak(from history: [String: Int]) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US_POSIX")

        // Get all dates with sessions > 0 and sort them
        let dates = history
            .filter { $0.value > 0 }  // Only count days with actual sessions
            .keys
            .compactMap { formatter.date(from: $0) }
            .sorted()

        guard !dates.isEmpty else { return 0 }

        var maxStreak = 1
        var currentStreak = 1

        for i in 1..<dates.count {
            let previousDate = dates[i - 1]
            let currentDate = dates[i]

            // Calculate days between dates
            let daysBetween = Calendar.current.dateComponents([.day], from: previousDate, to: currentDate).day ?? 0

            if daysBetween == 1 {
                // Consecutive day
                currentStreak += 1
                maxStreak = max(maxStreak, currentStreak)
            } else {
                // Streak broken
                currentStreak = 1
            }
        }

        return maxStreak
    }

    /// Calculate current streak from historical data to today
    private func calculateCurrentStreak(from history: [String: Int]) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US_POSIX")

        let today = Calendar.current.startOfDay(for: Date())

        // Get all dates with sessions > 0 and sort them (newest first)
        let dates = history
            .filter { $0.value > 0 }  // Only count days with actual sessions
            .keys
            .compactMap { formatter.date(from: $0) }
            .map { Calendar.current.startOfDay(for: $0) }
            .sorted(by: >)

        guard !dates.isEmpty else { return 0 }

        // Check if most recent date is today or yesterday
        let mostRecent = dates[0]
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!

        // If most recent is not today or yesterday, streak is broken
        if mostRecent != today && mostRecent != yesterday {
            return 0
        }

        // Count consecutive days backward from most recent
        var streak = 1
        for i in 1..<dates.count {
            let newerDate = dates[i - 1]  // More recent date
            let olderDate = dates[i]      // Older date

            // Calculate days between: should be exactly 1 for consecutive days
            let daysBetween = Calendar.current.dateComponents([.day], from: olderDate, to: newerDate).day ?? 0

            if daysBetween == 1 {
                streak += 1
            } else {
                // Streak broken
                break
            }
        }

        return streak
    }

    /// Save unlocked achievements to UserDefaults
    private func saveAchievements() {
        let unlocked = achievements
            .filter { $0.isUnlocked }
            .reduce(into: [String: Date]()) { result, achievement in
                if let date = achievement.unlockedDate {
                    result[achievement.id] = date
                }
            }

        if let data = try? JSONEncoder().encode(unlocked) {
            UserDefaults.standard.set(data, forKey: achievementsKey)
        }
    }

    /// Check and unlock session-based achievements
    func checkSessionAchievements(totalSessions: Int) {
        let sessionMilestones = [
            AchievementType.firstSession,
            AchievementType.sessions10,
            AchievementType.sessions50,
            AchievementType.sessions100,
            AchievementType.sessions500,
            AchievementType.sessions1000
        ]

        for type in sessionMilestones {
            if let index = achievements.firstIndex(where: { $0.id == type.rawValue }),
               !achievements[index].isUnlocked,
               totalSessions >= achievements[index].requirement {
                unlockAchievement(at: index)
            }
        }
    }

    /// Update current streak from dailyHistory
    private func updateCurrentStreak() {
        if let data = UserDefaults.standard.data(forKey: "dailyHistory"),
           let history = try? JSONDecoder().decode([String: Int].self, from: data) {
            let currentStreak = calculateCurrentStreak(from: history)
            UserDefaults.standard.set(currentStreak, forKey: currentStreakKey)
        }
    }

    /// Check and update streak-based achievements
    func checkStreakAchievements() {
        // Calculate current streak from dailyHistory
        if let data = UserDefaults.standard.data(forKey: "dailyHistory"),
           let history = try? JSONDecoder().decode([String: Int].self, from: data) {
            let currentStreak = calculateCurrentStreak(from: history)

            // Save current streak
            UserDefaults.standard.set(currentStreak, forKey: currentStreakKey)

            // Check streak achievements
            let streakMilestones = [
                AchievementType.streak7,
                AchievementType.streak30,
                AchievementType.streak100
            ]

            for type in streakMilestones {
                if let index = achievements.firstIndex(where: { $0.id == type.rawValue }),
                   !achievements[index].isUnlocked,
                   currentStreak >= achievements[index].requirement {
                    unlockAchievement(at: index)
                }
            }

            // Trigger review request after 7-day streak milestone
            ReviewRequestManager.shared.checkAndRequestReview(trigger: .streakMilestone)
        }
    }

    /// Unlock an achievement with optional custom date
    private func unlockAchievement(at index: Int, date: Date? = nil) {
        achievements[index].isUnlocked = true
        achievements[index].unlockedDate = date ?? Date()
        newlyUnlockedAchievements.append(achievements[index])
        saveAchievements()

        // Send notification only for real-time unlocks (not during migration)
        if date == nil {
            sendAchievementNotification(achievement: achievements[index])
            // Notify UI to update badge
            NotificationCenter.default.post(name: NSNotification.Name("AchievementUnlocked"), object: nil)
        }
    }

    /// Send system notification for achievement unlock
    private func sendAchievementNotification(achievement: Achievement) {
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("🏆 Achievement Unlocked!", comment: "Achievement notification title")
        content.body = String(format: NSLocalizedString("You've earned the \"%@\" badge!", comment: "Achievement notification body"), achievement.title)
        // Use a more prominent sound for achievement unlocks
        content.sound = UNNotificationSound(named: UNNotificationSoundName("Glass.aiff"))

        // Use achievement_ prefix to identify achievement notifications
        let identifier = "achievement_\(achievement.id)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending achievement notification: \(error)")
            }
        }
    }

    /// Clear newly unlocked achievements (after showing notification)
    func clearNewlyUnlocked() {
        newlyUnlockedAchievements.removeAll()
        // Notify UI to clear badge
        NotificationCenter.default.post(name: NSNotification.Name("AchievementUnlocked"), object: nil)
    }

    /// Get unlocked count
    var unlockedCount: Int {
        achievements.filter { $0.isUnlocked }.count
    }

    /// Get total count
    var totalCount: Int {
        achievements.count
    }

    /// Get current streak
    var currentStreak: Int {
        UserDefaults.standard.integer(forKey: currentStreakKey)
    }

    /// Format date as yyyy-MM-dd
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
    }

    #if DEBUG
    /// Test method: Unlock the next locked achievement (for testing notification and badge)
    func testUnlockNextAchievement() {
        // Find first locked achievement
        if let index = achievements.firstIndex(where: { !$0.isUnlocked }) {
            print("🔧 Debug: Unlocking achievement: \(achievements[index].title)")
            unlockAchievement(at: index)
        } else {
            print("🔧 Debug: All achievements already unlocked!")
        }
    }
    #endif
}
