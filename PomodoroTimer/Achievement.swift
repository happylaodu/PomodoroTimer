//
//  Achievement.swift
//  PomodoroTimer
//
//  Created by Steven Du on 2026-03-11.
//

import Foundation

/// Represents an achievement that can be unlocked
struct Achievement: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let icon: String // SF Symbol name
    let requirement: Int // Number required to unlock (sessions, days, etc.)
    var isUnlocked: Bool
    var unlockedDate: Date?

    init(id: String, title: String, description: String, icon: String, requirement: Int) {
        self.id = id
        self.title = title
        self.description = description
        self.icon = icon
        self.requirement = requirement
        self.isUnlocked = false
        self.unlockedDate = nil
    }
}

/// Types of achievements available
enum AchievementType: String, CaseIterable {
    case firstSession = "first_session"
    case sessions10 = "sessions_10"
    case sessions50 = "sessions_50"
    case sessions100 = "sessions_100"
    case sessions500 = "sessions_500"
    case sessions1000 = "sessions_1000"
    case streak7 = "streak_7"
    case streak30 = "streak_30"
    case streak100 = "streak_100"

    var achievement: Achievement {
        switch self {
        case .firstSession:
            return Achievement(
                id: rawValue,
                title: NSLocalizedString("achievement.first_session.title", comment: "First Focus"),
                description: NSLocalizedString("achievement.first_session.desc", comment: "Complete your first pomodoro session"),
                icon: "star.fill",
                requirement: 1
            )
        case .sessions10:
            return Achievement(
                id: rawValue,
                title: NSLocalizedString("achievement.sessions_10.title", comment: "Getting Started"),
                description: NSLocalizedString("achievement.sessions_10.desc", comment: "Complete 10 pomodoro sessions"),
                icon: "flame.fill",
                requirement: 10
            )
        case .sessions50:
            return Achievement(
                id: rawValue,
                title: NSLocalizedString("achievement.sessions_50.title", comment: "Dedicated"),
                description: NSLocalizedString("achievement.sessions_50.desc", comment: "Complete 50 pomodoro sessions"),
                icon: "bolt.fill",
                requirement: 50
            )
        case .sessions100:
            return Achievement(
                id: rawValue,
                title: NSLocalizedString("achievement.sessions_100.title", comment: "Centurion"),
                description: NSLocalizedString("achievement.sessions_100.desc", comment: "Complete 100 pomodoro sessions"),
                icon: "crown.fill",
                requirement: 100
            )
        case .sessions500:
            return Achievement(
                id: rawValue,
                title: NSLocalizedString("achievement.sessions_500.title", comment: "Master of Focus"),
                description: NSLocalizedString("achievement.sessions_500.desc", comment: "Complete 500 pomodoro sessions"),
                icon: "sparkles",
                requirement: 500
            )
        case .sessions1000:
            return Achievement(
                id: rawValue,
                title: NSLocalizedString("achievement.sessions_1000.title", comment: "Legend"),
                description: NSLocalizedString("achievement.sessions_1000.desc", comment: "Complete 1000 pomodoro sessions"),
                icon: "diamond.fill",
                requirement: 1000
            )
        case .streak7:
            return Achievement(
                id: rawValue,
                title: NSLocalizedString("achievement.streak_7.title", comment: "Week Warrior"),
                description: NSLocalizedString("achievement.streak_7.desc", comment: "Use the app for 7 consecutive days"),
                icon: "calendar.badge.checkmark",
                requirement: 7
            )
        case .streak30:
            return Achievement(
                id: rawValue,
                title: NSLocalizedString("achievement.streak_30.title", comment: "Monthly Master"),
                description: NSLocalizedString("achievement.streak_30.desc", comment: "Use the app for 30 consecutive days"),
                icon: "calendar.circle.fill",
                requirement: 30
            )
        case .streak100:
            return Achievement(
                id: rawValue,
                title: NSLocalizedString("achievement.streak_100.title", comment: "Consistency Champion"),
                description: NSLocalizedString("achievement.streak_100.desc", comment: "Use the app for 100 consecutive days"),
                icon: "medal.fill",
                requirement: 100
            )
        }
    }
}
