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

    var body: some View {
        Chart {
            ForEach(stats.sorted(by: { $0.key < $1.key }), id: \.key) { date, count in
                BarMark(
                    x: .value(NSLocalizedString("Date", comment: ""), date, unit: .day),
                    y: .value(NSLocalizedString("Count", comment: ""), count)
                )
            }
        }
        .chartXAxisLabel(position: .bottom, alignment: .center) {
            Text(NSLocalizedString("Date", comment: "Chart X-axis label"))
                .padding(.top, 8)
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day)) { value in
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
        .padding(.leading, 16)
        .padding(.trailing, 24)
        .padding(.vertical, 16)
    }
}

struct ContentView: View {
    //@StateObject var timer = PomodoroTimer()
    @ObservedObject var timer: PomodoroTimer
    @State private var displayMode: Int = 0 // 0: Today, 1: This Week, 2: Total
    @State private var showStatsPopover = false
    
    var body: some View {
        let totalTime = timer.state == .work ? 25 * 60 : 5 * 60
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
                    Button(action: {
                        displayMode = (displayMode + 1) % 3
                    }) {
                        Text({
                            switch displayMode {
                            case 1:
                                return String(format: NSLocalizedString("This Week: %d 🍅", comment: ""), timer.weeklyWorkSessions)
                            case 2:
                                return String(format: NSLocalizedString("Total: %d 🍅", comment: ""), timer.totalWorkSessions)
                            default:
                                return String(format: NSLocalizedString("Today: %d 🍅", comment: ""), timer.dailyWorkSessions)
                            }
                        }())
                        .font(.body.weight(.semibold))
                        .padding(.top, 4)
                    }
                    .buttonStyle(.plain)

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
            
            Button(action: {
                showStatsPopover.toggle()
            }) {
                Label(NSLocalizedString("Show Chart", comment: ""), systemImage: "chart.bar")
                    .labelStyle(.iconOnly)
                    .padding(.bottom, 4)
            }
            .popover(isPresented: $showStatsPopover) {
                StatsView(stats: Dictionary(uniqueKeysWithValues: timer.lastNDaysHistory(7).map { (PomodoroTimer.dateFormatter.date(from: $0.0) ?? Date(), $0.1) }))
                .frame(width: 360, height: 220)
            }
            .buttonStyle(.plain)
            .help(NSLocalizedString("Show past 7 days progress chart", comment: ""))


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
        .frame(width: 280, height: 320)
    }

    func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
}

