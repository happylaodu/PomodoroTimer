//
//  ContentView.swift
//  PomodoroTimer
//
//  Created by Steven Du on 2025-07-11.
//

import SwiftUI

struct ContentView: View {
    //@StateObject var timer = PomodoroTimer()
    @ObservedObject var timer: PomodoroTimer
    @State private var showTotal = false
    
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
                        showTotal.toggle()
                    }) {
                        Text(showTotal ? "Total: \(timer.totalWorkSessions) 🍅" : "Today: \(timer.dailyWorkSessions) 🍅")
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
