//
//  ContentView.swift
//  PomodoroTimer
//
//  Created by Steven Du on 2025-07-11.
//

import SwiftUI
import Charts
import AppKit

struct StatsView: View {
    var stats: [Date: Int]
    var isWeekly: Bool = false
    @State private var selectedDate: Date?
    @State private var hoverLocation: CGPoint = .zero

    private var sortedStats: [(Date, Int)] {
        stats.sorted(by: { $0.key < $1.key })
    }

    private var chartWidth: CGFloat {
        let dataPoints = stats.count
        let minWidth: CGFloat = 850 // Minimum width for container (increased)
        let widthPerPoint: CGFloat = isWeekly ? 25 : 22 // Width per data point
        // Add extra 120px: 60 for left padding + 60 for right padding (rotated labels need more space)
        let calculatedWidth = CGFloat(dataPoints) * widthPerPoint + 120
        return max(minWidth, calculatedWidth)
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            Chart {
                ForEach(sortedStats, id: \.0) { date, count in
                    BarMark(
                        x: .value(NSLocalizedString("Date", comment: ""), date, unit: isWeekly ? .weekOfYear : .day),
                        y: .value(NSLocalizedString("Count", comment: ""), count)
                    )
                    .foregroundStyle(selectedDate == date ? Color.accentColor.opacity(0.8) : Color.accentColor)
                }
            }
            .chartXAxisLabel(position: .bottom, alignment: .center) {
                Text(isWeekly ? NSLocalizedString("Week", comment: "Chart X-axis label") : NSLocalizedString("Date", comment: "Chart X-axis label"))
                    .padding(.top, 8)
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: isWeekly ? .weekOfYear : .day)) { value in
                    AxisGridLine()
                    AxisValueLabel {
                        if let date = value.as(Date.self) {
                            Text(date.formatted(.dateTime.month().day()))
                                .font(.caption2)
                                .rotationEffect(.degrees(-40))
                                .offset(x: -8, y: 8)
                        }
                    }
                }
            }
            .chartYAxisLabel(NSLocalizedString("Work Round Count", comment: "Chart Y-axis label"), position: .leading, alignment: .center)
            .frame(width: chartWidth)
            .padding(.leading, 16)
            .padding(.trailing, 60)
            .padding(.top, 16)
            .padding(.bottom, 40)
            .onContinuousHover { phase in
                switch phase {
                case .active(let location):
                    hoverLocation = location
                    updateSelectedDate(at: location)
                case .ended:
                    selectedDate = nil
                }
            }
            .overlay(alignment: .topLeading) {
                if let selectedDate = selectedDate,
                   let count = stats[selectedDate] {
                    let tooltipWidth: CGFloat = 140 // Estimated tooltip width
                    let tooltipHeight: CGFloat = 50 // Estimated tooltip height

                    // Check if tooltip would go off the right edge
                    let showOnLeft = (hoverLocation.x + tooltipWidth/2) > chartWidth
                    // Check if tooltip would go off the top edge
                    let showBelow = hoverLocation.y < tooltipHeight

                    let xOffset = showOnLeft ? hoverLocation.x  - tooltipWidth/2 : hoverLocation.x
                    let yOffset = showBelow ? hoverLocation.y + 10 : hoverLocation.y

                    VStack(spacing: 2) {
                        Text(formatDate(selectedDate))
                            .font(.caption)
                            .fontWeight(.semibold)
                        Text("\(count) \(count == 1 ? NSLocalizedString("session", comment: "") : NSLocalizedString("sessions", comment: ""))")
                            .font(.caption2)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.primary.opacity(0.9))
                    )
                    .foregroundColor(Color(NSColor.controlBackgroundColor))
                    .offset(x: xOffset, y: yOffset)
                }
            }
        }
    }

    private func updateSelectedDate(at location: CGPoint) {
        guard !sortedStats.isEmpty else { return }

        // Account for padding
        let leadingPadding: CGFloat = 16  // .padding(.leading, 16)
        let yAxisSpace: CGFloat = 22       // Approximate Y-axis label space
        let plotStartX = leadingPadding + yAxisSpace

        // Calculate position within the plot area
        let xInPlot = location.x - plotStartX

        // Calculate available plot width
        let trailingPadding: CGFloat = 22  // .padding(.trailing, 60)
        let plotWidth = chartWidth - leadingPadding - yAxisSpace
        //let plotWidth = chartWidth


        guard xInPlot >= 0 && xInPlot <= plotWidth else {
            selectedDate = nil
            return
        }

        // Find the bar index - round to nearest instead of truncating
        let barWidth = plotWidth / CGFloat(sortedStats.count)
        let index = Int(((xInPlot - barWidth/2) / barWidth).rounded())

        if index >= 0 && index < sortedStats.count {
            selectedDate = sortedStats[index].0
        } else if index == -1 {
            selectedDate = sortedStats[0].0
        }
        else {
            selectedDate = nil
        }
    }

    private func formatDate(_ date: Date) -> String {
        if isWeekly {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            let calendar = Calendar.current
            let weekEnd = calendar.date(byAdding: .day, value: 6, to: date) ?? date
            return "\(formatter.string(from: date)) - \(formatter.string(from: weekEnd))"
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
    }
}

struct ContentView: View {
    //@StateObject var timer = PomodoroTimer()
    @ObservedObject var timer: PomodoroTimer
    @ObservedObject var achievementManager = AchievementManager.shared

    var body: some View {
        let totalTime = timer.state == .work ? timer.workDuration * 60 : timer.currentRestDuration * 60
        let progress = Double(timer.timeRemaining) / Double(totalTime)

        VStack(spacing: 20) {
            ZStack {
                Text(timer.state == .rest ? (timer.isLongRest ? NSLocalizedString("Long Rest Time", comment: "") : NSLocalizedString("Rest Time", comment: "")) : NSLocalizedString("Work Time", comment: ""))
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .center)
                HStack {
                    if !timer.isRunning {
                        Button(action: { timer.toggleCurrentPhase() }) {
                            Image(systemName: "arrow.triangle.2.circlepath")
                        }
                        .buttonStyle(.plain)
                        .help(NSLocalizedString("Switch Current Phase", comment: ""))
                        .padding(.trailing, 6)
                    }
                    Spacer()
                    Button(action: { SettingsWindowController.shared.show() }) {
                        Image(systemName: "gearshape")
                    }
                    .buttonStyle(.plain)
                    .help(NSLocalizedString("Open Settings", comment: ""))
                }
            }
            .padding(.bottom, 4)
            
            ZStack {
                Circle()
                    .stroke(lineWidth: 6)
                    .foregroundColor(.gray.opacity(0.2))
                    .frame(width: 160, height: 160)

                Circle()
                    .trim(from: 0, to: 1 - progress)
                    .stroke(
                        timer.state == .work ? Color.red : Color.green,
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .frame(width: 160, height: 160)

                VStack(spacing: 6)
                {
                    // Achievement button with badge indicator
                    ZStack(alignment: .topTrailing) {
                        Button(action: {
                            showAchievements()
                        }) {
                            HStack(spacing: 4) {
                                Text("🏆")
                                Text("\(achievementManager.unlockedCount)/\(achievementManager.totalCount)")
                                    .font(.body.weight(.semibold))
                            }
                            .padding(.top, 4)
                        }
                        .buttonStyle(.plain)
                        .help(NSLocalizedString("View Achievements", comment: ""))
                        .onHover { isHovering in
                            if isHovering {
                                NSCursor.pointingHand.push()
                            } else {
                                NSCursor.pop()
                            }
                        }

                        // Badge indicator for new achievements
                        if !achievementManager.newlyUnlockedAchievements.isEmpty {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 16, height: 16)
                                .overlay(
                                    Text("\(achievementManager.newlyUnlockedAchievements.count)")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(.white)
                                )
                                .offset(x: 14, y: -4)
                        }
                    }

                    Text(timeString(from: timer.timeRemaining))
                        .font(.system(size: 48, weight: .bold, design: .monospaced))

                    Button(action: {
                        if timer.isRunning {
                            timer.pause()
                        } else {
                            timer.start()
                        }
                    }) {
                        Image(systemName: timer.isRunning ? "pause.fill" : "play.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 36, height: 36)
                            .background(Circle().fill(Color.accentColor))
                    }
                    .buttonStyle(.plain)

                }
                .offset(y: 0)
            }
            
            // Compact stats section
            HStack(spacing: 12) {
                HStack(spacing: 4) {
                    Text(String(format: NSLocalizedString("Today: %d", comment: ""), timer.dailyWorkSessions))
                        .font(.system(size: 13))
                    Text("🍅")
                }
                Text("|")
                    .foregroundColor(.secondary)
                HStack(spacing: 4) {
                    Text(String(format: NSLocalizedString("This week: %d", comment: ""), timer.weeklyWorkSessions))
                        .font(.system(size: 13))
                    Text("🍅")
                }
            }
            .foregroundColor(.primary)
            .padding(.top, 4)


            HStack(spacing: 20) {
                Button(action: {
                    timer.reset()
                }) {
                    Label(NSLocalizedString("Reset", comment: ""), systemImage: "arrow.counterclockwise")
                }
                .buttonStyle(.bordered)

                Divider()
                       .frame(height: 20)
                
                Button {
                    if timer.isRunning {
                        timer.pause()
                    }
                    NSApp.terminate(nil)
                } label: {
                    Label(NSLocalizedString("Quit", comment: ""), systemImage: "door.left.hand.open")
                }
                .buttonStyle(.bordered)
                .tint(.red)
                .help(NSLocalizedString("Quit Pomodoro Timer Lite", comment: ""))
            }
        }
        .padding()
        .frame(width: 280, height: 360)
    }

    func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }

    private func showAchievements() {
        AchievementsWindowController.shared.show()
        // Badge will be cleared when user dismisses the congratulations banner
    }
}

