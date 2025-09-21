//
//  ContentView.swift
//  PomodoroTimer
//
//  Created by Steven Du on 2025-07-11.
//

import SwiftUI
import Charts

struct StatsView: View {
    var stats: [Date: Int]

    var body: some View {
        Chart {
            ForEach(stats.sorted(by: { $0.key < $1.key }), id: \.key) { date, count in
                BarMark(
                    x: .value("Date", date, unit: .day),
                    y: .value("Count", count)
                )
            }
        }
        .chartXAxisLabel("Date", position: .bottom, alignment: .center)
        .chartXAxis {
            AxisMarks(values: .stride(by: .day)) { value in
                AxisGridLine()
                AxisValueLabel {
                    if let date = value.as(Date.self) {
                        Text(date.formatted(.dateTime.month().day().locale(Locale(identifier: "en_US"))))
                            .font(.caption2)
                            .rotationEffect(.degrees(-40))
                            .frame(width: 30, alignment: .trailing)
                    }
                }
            }
        }
        .chartYAxisLabel("Work Round Count", position: .leading, alignment: .center)
        .padding()
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
            
            
            HStack {
                Text(timer.state == .rest ? "Rest Time" : "Work Time")
                    .font(.largeTitle)

                if !timer.isRunning {
                    Button(action: {
                        timer.toggleCurrentPhase()
                    }) {
                        Image(systemName: "arrow.triangle.2.circlepath") // 或 "repeat"
                    }
                    .buttonStyle(.plain)
                    .help("切换当前阶段")
                }
            }

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
                    .animation(.linear(duration: 0.2), value: progress)

                VStack(spacing: 6)
                {
                    Button(action: {
                        displayMode = (displayMode + 1) % 3
                    }) {
                        Text({
                            switch displayMode {
                            case 1:
                                return "This Week: \(timer.weeklyWorkSessions) 🍅"
                            case 2:
                                return "Total: \(timer.totalWorkSessions) 🍅"
                            default:
                                return "Today: \(timer.dailyWorkSessions) 🍅"
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
                Label("Show Chart", systemImage: "chart.bar")
                    .labelStyle(.iconOnly)
                    .padding(.bottom, 4)
            }
            .popover(isPresented: $showStatsPopover) {
                StatsView(stats: Dictionary(uniqueKeysWithValues: timer.lastNDaysHistory(7).map { (PomodoroTimer.dateFormatter.date(from: $0.0) ?? Date(), $0.1) }))
                .frame(width: 240, height: 180)
            }
            .buttonStyle(.plain)
            .help("Show past 7 days progress chart")


            HStack(spacing: 20) {
                Button(action: {
                    timer.reset()
                }) {
                    Label("Reset", systemImage: "arrow.counterclockwise")
                }
                .buttonStyle(.bordered)

                Divider()
                       .frame(height: 20)
                
                Button {
                    NSApp.terminate(nil)
                } label: {
                    Label("Quit", systemImage: "door.left.hand.open")
                }
                .buttonStyle(.bordered)
                .tint(.red)
                .help("Quit Pomodoro Timer Lite")
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
