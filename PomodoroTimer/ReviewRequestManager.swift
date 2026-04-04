//
//  ReviewRequestManager.swift
//  PomodoroTimer
//
//  Created by Steven Du on 2026-03-25.
//

import Foundation
import StoreKit
import AppKit

class ReviewRequestManager {
    static let shared = ReviewRequestManager()

    private let lastReviewRequestDateKey = "lastReviewRequestDate"
    private let reviewRequestCountKey = "reviewRequestCount"
    private let minimumDaysBetweenRequests = 90

    private init() {}

    /// Check if we should request a review based on milestone triggers
    func checkAndRequestReview(trigger: ReviewTrigger) {
        guard shouldRequestReview() else { return }

        let totalSessions = UserDefaults.standard.integer(forKey: "totalWorkSessions")
        let currentStreak = UserDefaults.standard.integer(forKey: "currentStreak")

        var shouldRequest = false

        switch trigger {
        case .sessionMilestone:
            // Check session milestones: 10, 50, 100
            shouldRequest = totalSessions == 10 || totalSessions == 50 || totalSessions == 100

        case .streakMilestone:
            // Check streak milestone: 7 consecutive days
            shouldRequest = currentStreak == 7

        case .statisticsExport:
            // Request after exporting statistics (if user is engaged enough)
            shouldRequest = totalSessions >= 10

        case .achievementUnlocked:
            // Request after unlocking significant achievements
            let significantMilestones = [10, 50, 100] // Sessions milestones
            shouldRequest = significantMilestones.contains(totalSessions)
        }

        if shouldRequest {
            requestReview()
        }
    }

    /// Check if enough time has passed since last review request
    private func shouldRequestReview() -> Bool {
        // Check if we've requested before
        guard let lastRequestDate = UserDefaults.standard.object(forKey: lastReviewRequestDateKey) as? Date else {
            // First time - allow request
            return true
        }

        // Calculate days since last request
        let daysSinceLastRequest = Calendar.current.dateComponents([.day], from: lastRequestDate, to: Date()).day ?? 0

        return daysSinceLastRequest >= minimumDaysBetweenRequests
    }

    /// Request App Store review
    private func requestReview() {
        // Update last request date
        UserDefaults.standard.set(Date(), forKey: lastReviewRequestDateKey)

        // Increment request count (for analytics)
        let currentCount = UserDefaults.standard.integer(forKey: reviewRequestCountKey)
        UserDefaults.standard.set(currentCount + 1, forKey: reviewRequestCountKey)

        // Request review on main thread (macOS API)
        DispatchQueue.main.async {
            // Use SKStoreReviewController for all macOS versions (12-15)
            // Note: Deprecated in macOS 15, but still functional
            SKStoreReviewController.requestReview()
        }

        print("✅ Review request triggered (total requests: \(currentCount + 1))")
    }

    /// Manually trigger review request (for testing or user-initiated)
    func manualRequestReview() {
        requestReview()
    }
}

// MARK: - Review Trigger Types

enum ReviewTrigger {
    case sessionMilestone       // After completing 10, 50, 100 pomodoros
    case streakMilestone        // After 7-day streak
    case statisticsExport       // After exporting statistics
    case achievementUnlocked    // After unlocking achievements
}
