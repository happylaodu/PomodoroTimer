//
//  AchievementsView.swift
//  PomodoroTimer
//
//  Created by Steven Du on 2026-03-11.
//

import SwiftUI
import Charts

struct AchievementsView: View {
    @ObservedObject var manager = AchievementManager.shared
    @ObservedObject var timer: PomodoroTimer

    var body: some View {
        VStack(spacing: 0) {
            // Summary Statistics - visible on both tabs (fixed values only)
            HStack(spacing: 24) {
                StatItem(
                    icon: "🍅",
                    color: .red,
                    label: NSLocalizedString("Total Sessions", comment: ""),
                    value: "\(timer.totalWorkSessions)"
                )

                Divider()
                    .frame(height: 24)

                StatItem(
                    icon: "calendar",
                    color: .blue,
                    label: NSLocalizedString("Total Days", comment: ""),
                    value: "\(timer.allTimeHistory().count)"
                )

                Divider()
                    .frame(height: 24)

                StatItem(
                    icon: "flame.fill",
                    color: .orange,
                    label: NSLocalizedString("Current Streak Days", comment: ""),
                    value: "\(manager.currentStreak)"
                )
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.secondary.opacity(0.1))
            )
            .padding(.horizontal)
            .padding(.top, 12)
            .padding(.bottom, 4)

            TabView {
                BadgesTab(manager: manager)
                    .tabItem {
                        Label(NSLocalizedString("Badges", comment: ""), systemImage: "trophy.fill")
                    }

                StatisticsTab(timer: timer)
                    .tabItem {
                        Label(NSLocalizedString("Statistics", comment: ""), systemImage: "chart.bar.fill")
                    }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 8)
        }
    }
}

enum StatsPeriod: String, CaseIterable {
    case week = "Last 7 Days"
    case month = "Last 30 Days"
    case all = "All Time"

    var days: Int? {
        switch self {
        case .week: return 7
        case .month: return 30
        case .all: return nil
        }
    }

    func displayTitle(for timer: PomodoroTimer) -> String {
        switch self {
        case .week: return NSLocalizedString("Last 7 Days", comment: "")
        case .month: return NSLocalizedString("Last 30 Days", comment: "")
        case .all:
            let weekCount = timer.weeklyHistory(maxWeeks: 52).count
            return weekCount >= 52
                ? NSLocalizedString("Last 52 Weeks", comment: "")
                : NSLocalizedString("All Time", comment: "")
        }
    }

    func getStats(from timer: PomodoroTimer) -> [(String, Int)] {
        switch self {
        case .week: return timer.lastNDaysHistory(7)
        case .month: return timer.lastNDaysHistory(30)
        case .all: return timer.weeklyHistory(maxWeeks: 52)
        }
    }
}

struct BadgesTab: View {
    @ObservedObject var manager: AchievementManager

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with congratulations banner occupying remaining space on the right
            HStack(spacing: 12) {
                // Left side: Badges title
                HStack(spacing: 8) {
                    Text(NSLocalizedString("Badges", comment: "Badges"))
                        .font(.title2)
                        .fontWeight(.bold)

                    Text("\(manager.unlockedCount)/\(manager.totalCount)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                }

                // Right side: Congratulations banner (if any new achievements) - fills remaining space
                if !manager.newlyUnlockedAchievements.isEmpty {
                    HStack(spacing: 8) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.title2)

                        Text(NSLocalizedString("🎉 Congratulations on unlocking new achievements!", comment: "New achievement banner"))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .lineLimit(1)

                        Spacer(minLength: 0)

                        Button(action: {
                            manager.clearNewlyUnlocked()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                                .font(.body)
                        }
                        .buttonStyle(.plain)
                        .help(NSLocalizedString("Dismiss", comment: ""))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.yellow.opacity(0.15))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.yellow.opacity(0.5), lineWidth: 1.5)
                            )
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Spacer()
                }
            }
            .padding(.bottom, 4)

            // Achievements Grid
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ForEach(manager.achievements) { achievement in
                        AchievementCard(achievement: achievement)
                    }
                }
                .padding(.bottom, 8)
            }
        }
    }
}

struct StatisticsTab: View {
    @ObservedObject var timer: PomodoroTimer
    @State private var selectedPeriod: StatsPeriod = .week

    private var statsData: (stats: [(String, Int)], title: String, isWeekly: Bool) {
        switch selectedPeriod {
        case .week:
            return (timer.lastNDaysHistory(7), NSLocalizedString("Daily Sessions", comment: ""), false)
        case .month:
            return (timer.lastNDaysHistory(30), NSLocalizedString("Daily Sessions", comment: ""), false)
        case .all:
            return (timer.weeklyHistory(maxWeeks: 52), NSLocalizedString("Weekly Sessions", comment: ""), true)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Text(NSLocalizedString("Statistics", comment: ""))
                    .font(.title2)
                    .fontWeight(.bold)

                Spacer()

                Picker("", selection: $selectedPeriod) {
                    ForEach(StatsPeriod.allCases, id: \.self) { period in
                        Text(period.displayTitle(for: timer)).tag(period)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 280)
            }
            .padding(.bottom, 4)

            // Chart
            VStack(alignment: .leading, spacing: 6) {
                Text(statsData.title)
                    .font(.caption)
                    .foregroundColor(.secondary)

                StatsView(stats: Dictionary(uniqueKeysWithValues: statsData.stats.map {
                    (PomodoroTimer.dateFormatter.date(from: $0.0) ?? Date(), $0.1)
                }), isWeekly: statsData.isWeekly)
                .frame(height: 380)
            }

            // Period-specific average
            if !statsData.stats.isEmpty {
                PeriodAverageView(stats: statsData.stats, isWeekly: statsData.isWeekly)
                    .padding(.top, 8)
            }

            Spacer(minLength: 0)
        }
    }
}

struct StatItem: View {
    let icon: String
    let color: Color
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 6) {
            // Support both SF Symbols and emoji
            if icon.count == 1 && icon.unicodeScalars.first?.properties.isEmoji == true {
                Text(icon)
                    .font(.body)
            } else {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.body)
            }

            VStack(alignment: .leading, spacing: 1) {
                Text(label)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.title3)
                    .fontWeight(.semibold)
            }
        }
    }
}

struct PeriodAverageView: View {
    let stats: [(String, Int)]
    let isWeekly: Bool

    private var weeklyAvg: Double {
        stats.isEmpty ? 0.0 : Double(stats.map { $0.1 }.reduce(0, +)) / Double(stats.count)
    }

    private var dailyAvg: Double {
        // For weekly data, divide weekly average by 7 to get daily average
        isWeekly ? weeklyAvg / 7.0 : weeklyAvg
    }

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .foregroundColor(.purple)
                .font(.title2)

            if isWeekly {
                // Show both weekly and daily averages for All Time view
                VStack(alignment: .leading, spacing: 2) {
                    Text(NSLocalizedString("Average per Week", comment: ""))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(String(format: "%.1f", weeklyAvg))
                        .font(.title)
                        .fontWeight(.bold)
                }

                Divider()
                    .frame(height: 40)

                VStack(alignment: .leading, spacing: 2) {
                    Text(NSLocalizedString("Average per Day", comment: ""))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(String(format: "%.1f", dailyAvg))
                        .font(.title)
                        .fontWeight(.bold)
                }
            } else {
                // Show only daily average for 7 Days and 30 Days views
                VStack(alignment: .leading, spacing: 2) {
                    Text(NSLocalizedString("Average per Day", comment: ""))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(String(format: "%.1f", dailyAvg))
                        .font(.title)
                        .fontWeight(.bold)
                }
            }

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.purple.opacity(0.1))
        )
    }
}

struct AchievementCard: View {
    let achievement: Achievement

    private var isNew: Bool {
        AchievementManager.shared.newlyUnlockedAchievements.contains { $0.id == achievement.id }
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 6) {
                // Icon
                Image(systemName: achievement.icon)
                    .font(.system(size: 32))
                    .foregroundColor(achievement.isUnlocked ? .accentColor : .gray)
                    .opacity(achievement.isUnlocked ? 1.0 : 0.3)

            // Title
            Text(achievement.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .foregroundColor(achievement.isUnlocked ? .primary : .secondary)

            // Description
            Text(achievement.description)
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .lineLimit(2)

                // Unlocked Date
                if achievement.isUnlocked, let date = achievement.unlockedDate {
                    Text(formatDate(date))
                        .font(.caption2)
                        .foregroundColor(.green)
                } else {
                    Text("\(achievement.requirement)")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity, minHeight: 150, maxHeight: 150)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(achievement.isUnlocked ? Color.accentColor.opacity(0.1) : Color.gray.opacity(0.05))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(achievement.isUnlocked ? Color.accentColor.opacity(0.3) : Color.gray.opacity(0.2), lineWidth: 1)
            )

            // NEW badge for newly unlocked achievements
            if isNew {
                Text("NEW")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(
                        Capsule()
                            .fill(Color.red)
                    )
                    .offset(x: -8, y: 8)
            }
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
    }
}

#Preview("Achievements View") {
    AchievementsView(timer: PomodoroTimer())
        .frame(width: 900, height: 650)
}

#Preview("Statistics Tab") {
    StatisticsTab(timer: PomodoroTimer())
        .frame(width: 900, height: 650)
}
