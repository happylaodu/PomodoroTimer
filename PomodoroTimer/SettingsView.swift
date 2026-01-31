//
//  SettingsView.swift
//  PomodoroTimer
//
//  Created by Steven Du on 2026-01-03.
//


import SwiftUI

struct SettingsView: View {
    @AppStorage("autoStartWork") private var autoStartWork = false
    @AppStorage("autoStartRest") private var autoStartRest = false
    @AppStorage("autoStartNextCycle") private var autoStartNextCycle = false

    @AppStorage("workDuration") private var workDuration = 25
    @AppStorage("shortRestDuration") private var shortRestDuration = 5
    @AppStorage("longRestDuration") private var longRestDuration = 15
    @AppStorage("roundsBeforeLongRest") private var roundsBeforeLongRest = 4

    @AppStorage("enableLongRest") private var enableLongRest = true

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("⏱ Auto Start Control")
                        .font(.title3).bold().foregroundColor(.accentColor)
                        .padding(.bottom, 4)
                    Toggle("Auto Start Work on First Launch Each Day", isOn: $autoStartWork)
                    Toggle("Auto Start Rest After Work", isOn: $autoStartRest)
                    Toggle("Auto Start Work After Rest", isOn: $autoStartNextCycle)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("⏲ Duration (Minutes)")
                        .font(.title3).bold().foregroundColor(.accentColor)
                        .padding(.bottom, 4)
                    Stepper("Work Duration: \(workDuration)", value: $workDuration, in: 15...90)
                    Stepper("Short Rest Duration: \(shortRestDuration)", value: $shortRestDuration, in: 3...30)
                    Toggle("Enable Long Rest", isOn: $enableLongRest)
                    Stepper("Long Rest After \(roundsBeforeLongRest) Rounds", value: $roundsBeforeLongRest, in: 2...10)
                        .disabled(!enableLongRest)
                        .foregroundStyle(enableLongRest ? .primary : .secondary)
                    Stepper("Long Rest Duration: \(longRestDuration)", value: $longRestDuration, in: 10...60)
                        .disabled(!enableLongRest)
                        .foregroundStyle(enableLongRest ? .primary : .secondary)
                }

            }
            .padding(.vertical, 16)
            .padding(.horizontal, 12)
            .controlSize(.small)
        }
        .toggleStyle(.switch)
        .frame(minWidth: 420, idealWidth: 420, minHeight: 380, idealHeight: 380)
    }
}

#Preview {
    SettingsView()
}

