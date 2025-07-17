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
                    .stroke(lineWidth: 8)
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

                VStack(spacing: 4) {
                    Text(showTotal ? "Total: \(timer.totalWorkSessions) 🍅" : "Today: \(timer.dailyWorkSessions) 🍅")
                        .font(.body.weight(.semibold))
                        .onTapGesture {
                            showTotal.toggle()
                        }

                    Text(timeString(from: timer.timeRemaining))
                        .font(.system(size: 48, weight: .bold, design: .monospaced))
                }
            }


            HStack(spacing: 20) {
                Button(action: {
                    if timer.isRunning {
                        timer.pause()
                    } else {
                        timer.start()
                    }
                }) {
                    Label(timer.isRunning ? "Pause" : (timer.isPaused ? "Resume" : "Start"),
                          systemImage: timer.isRunning ? "pause.fill" : "play.fill")
                }
                .buttonStyle(.borderedProminent)
                
                Button("Reset") {
                    timer.reset()
                }
            }
            .buttonStyle(.borderedProminent)

            Button {
                NSApp.terminate(nil)
            } label: {
                Label("Quit", systemImage: "door.left.hand.open")
            }
            .buttonStyle(.bordered)
            .foregroundColor(.red)
            .help("Quit Pomodoro Timer Lite")
        }
        .padding()
        .frame(width: 280, height: 350)
    }

    func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
}
