//
//  SettingsView.swift
//  PomodoroTimer
//
//  Created by Steven Du on 2026-01-03.
//


import SwiftUI
import ServiceManagement

struct SettingsView: View {
    @AppStorage("launchAtLogin") private var launchAtLogin = false
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
                    Text(NSLocalizedString("⏱ Auto Start Control", comment: ""))
                        .font(.title3).bold().foregroundColor(.accentColor)
                        .padding(.bottom, 4)
                    Toggle(NSLocalizedString("Start automatically when computer starts", comment: ""), isOn: $launchAtLogin)
                        .onChange(of: launchAtLogin) { _, newValue in
                            updateLaunchAtLogin(enabled: newValue)
                        }
                    Toggle(NSLocalizedString("Auto Start Work on First Launch Each Day", comment: ""), isOn: $autoStartWork)
                    Toggle(NSLocalizedString("Auto Start Rest After Work", comment: ""), isOn: $autoStartRest)
                    Toggle(NSLocalizedString("Auto Start Work After Rest", comment: ""), isOn: $autoStartNextCycle)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text(NSLocalizedString("⏲ Duration (Minutes)", comment: ""))
                        .font(.title3).bold().foregroundColor(.accentColor)
                        .padding(.bottom, 4)
                    Stepper(String(format: NSLocalizedString("Work Duration: %d", comment: ""), workDuration), value: $workDuration, in: 15...90)
                    Stepper(String(format: NSLocalizedString("Short Rest Duration: %d", comment: ""), shortRestDuration), value: $shortRestDuration, in: 3...30)
                    Toggle(NSLocalizedString("Enable Long Rest", comment: ""), isOn: $enableLongRest)
                    Stepper(String(format: NSLocalizedString("Long Rest After %d Rounds", comment: ""), roundsBeforeLongRest), value: $roundsBeforeLongRest, in: 2...10)
                        .disabled(!enableLongRest)
                        .foregroundStyle(enableLongRest ? .primary : .secondary)
                    Stepper(String(format: NSLocalizedString("Long Rest Duration: %d", comment: ""), longRestDuration), value: $longRestDuration, in: 10...60)
                        .disabled(!enableLongRest)
                        .foregroundStyle(enableLongRest ? .primary : .secondary)
                }

            }
            .padding(.vertical, 16)
            .padding(.horizontal, 12)
            .controlSize(.small)
        }
        .toggleStyle(.switch)
        .frame(minWidth: 420, idealWidth: 420, minHeight: 420, idealHeight: 420)
    }

    private func updateLaunchAtLogin(enabled: Bool) {
        do {
            if enabled {
                try SMAppService.mainApp.register()
                print("✅ App registered to launch at login")
            } else {
                try SMAppService.mainApp.unregister()
                print("✅ App unregistered from launch at login")
            }
        } catch {
            print("❌ Failed to update launch at login: \(error)")
        }
    }
}

#Preview {
    SettingsView()
}

