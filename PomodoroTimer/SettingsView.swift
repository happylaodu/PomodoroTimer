//
//  SettingsView.swift
//  PomodoroTimer
//
//  Created by Steven Du on 2026-01-03.
//


import SwiftUI
import ServiceManagement
import AppKit

struct SettingsView: View {
    var timer: PomodoroTimer?

    @AppStorage("launchAtLogin") private var launchAtLogin = true
    @AppStorage("autoStartWork") private var autoStartWork = false
    @AppStorage("autoStartRest") private var autoStartRest = false
    @AppStorage("autoStartNextCycle") private var autoStartNextCycle = false

    @AppStorage("workDuration") private var workDuration = 25
    @AppStorage("shortRestDuration") private var shortRestDuration = 5
    @AppStorage("longRestDuration") private var longRestDuration = 15
    @AppStorage("roundsBeforeLongRest") private var roundsBeforeLongRest = 4

    @AppStorage("enableLongRest") private var enableLongRest = true

    @AppStorage("notificationSound") private var notificationSound = "Ping"
    @AppStorage("soundEnabled") private var soundEnabled = true

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(NSLocalizedString("⏱ Auto Start Control", comment: ""))
                        .font(.title3).bold().foregroundColor(.accentColor)
                        .padding(.bottom, 4)
                    Toggle(NSLocalizedString("Start automatically when computer starts", comment: ""), isOn: $launchAtLogin)
                        .onChange(of: launchAtLogin) { newValue in
                            updateLaunchAtLogin(enabled: newValue)
                        }
                    Toggle(NSLocalizedString("Auto Start Work on First Launch Each Day", comment: ""), isOn: $autoStartWork)
                    Toggle(NSLocalizedString("Auto Start Rest After Work", comment: ""), isOn: $autoStartRest)
                    Toggle(NSLocalizedString("Auto Start Work After Rest", comment: ""), isOn: $autoStartNextCycle)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text(NSLocalizedString("🔔 Sound", comment: ""))
                        .font(.title3).bold().foregroundColor(.accentColor)
                        .padding(.bottom, 4)
                    Toggle(NSLocalizedString("Enable Sound", comment: ""), isOn: $soundEnabled)

                    Picker(NSLocalizedString("Notification Sound", comment: ""), selection: $notificationSound) {
                        Text(NSLocalizedString("Ping", comment: "")).tag("Ping")
                        Text(NSLocalizedString("Glass", comment: "")).tag("Glass")
                        Text(NSLocalizedString("Hero", comment: "")).tag("Hero")
                        Text(NSLocalizedString("Tink", comment: "")).tag("Tink")
                        Text(NSLocalizedString("Purr", comment: "")).tag("Purr")
                        Text(NSLocalizedString("Basso", comment: "")).tag("Basso")
                        Text(NSLocalizedString("Blow", comment: "")).tag("Blow")
                        Text(NSLocalizedString("Bottle", comment: "")).tag("Bottle")
                        Text(NSLocalizedString("Frog", comment: "")).tag("Frog")
                        Text(NSLocalizedString("Funk", comment: "")).tag("Funk")
                        Text(NSLocalizedString("Pop", comment: "")).tag("Pop")
                        Text(NSLocalizedString("Sosumi", comment: "")).tag("Sosumi")
                    }
                    .disabled(!soundEnabled)
                    .foregroundStyle(soundEnabled ? .primary : .secondary)
                    .onChange(of: notificationSound) { newValue in
                        previewSound(newValue)
                    }
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

                VStack(alignment: .leading, spacing: 10) {
                    Text(NSLocalizedString("📊 Statistics Export", comment: ""))
                        .font(.title3).bold().foregroundColor(.accentColor)
                        .padding(.bottom, 4)

                    HStack {
                        Button(NSLocalizedString("Export to CSV", comment: "")) {
                            exportCSV()
                        }
                        .buttonStyle(.bordered)

                        Button(NSLocalizedString("Weekly Report (PDF)", comment: "")) {
                            exportPDF(reportType: .weekly)
                        }
                        .buttonStyle(.bordered)
                    }

                    HStack {
                        Button(NSLocalizedString("Monthly Report (PDF)", comment: "")) {
                            exportPDF(reportType: .monthly)
                        }
                        .buttonStyle(.bordered)

                        Button(NSLocalizedString("All-Time Report (PDF)", comment: "")) {
                            exportPDF(reportType: .all)
                        }
                        .buttonStyle(.bordered)
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text(NSLocalizedString("⌨️ Keyboard Shortcuts", comment: ""))
                        .font(.title3).bold().foregroundColor(.accentColor)
                        .padding(.bottom, 4)
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(NSLocalizedString("Show Window", comment: ""))
                                .frame(width: 100, alignment: .leading)
                            Spacer()
                            Text("⌘ ⇧ T")
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.secondary)
                        }
                        HStack {
                            Text(NSLocalizedString("Start/Pause", comment: ""))
                                .frame(width: 100, alignment: .leading)
                            Spacer()
                            Text("⌘ ⇧ P")
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.secondary)
                        }
                        HStack {
                            Text(NSLocalizedString("Reset", comment: ""))
                                .frame(width: 100, alignment: .leading)
                            Spacer()
                            Text("⌘ ⇧ R")
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.secondary)
                        }
                        HStack {
                            Text(NSLocalizedString("Switch Mode", comment: ""))
                                .frame(width: 100, alignment: .leading)
                            Spacer()
                            Text("⌘ ⇧ M")
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.secondary)
                        }
                    }
                    .font(.system(size: 13))

                    Text(NSLocalizedString("💡 Tip: If you don't see the tomato icon in the menu bar, use ⌘⇧T to show the window and locate the icon. To reposition: hold ⌘ and drag less-used icons to the left (hidden area) to make room for frequently-used apps.", comment: ""))
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .padding(.top, 8)
                        .fixedSize(horizontal: false, vertical: true)
                }

            }
            .padding(.vertical, 20)
            .padding(.horizontal, 24)
            .controlSize(.small)
        }
        .toggleStyle(.switch)
        .frame(minWidth: 420, idealWidth: 420, minHeight: 720, idealHeight: 720)
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

    private func previewSound(_ soundName: String) {
        guard soundEnabled else { return }
        guard let sound = NSSound(named: NSSound.Name(soundName)) else { return }

        // Play 3 times with 0.5s interval, same as actual notification
        for i in 0..<3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.5) {
                sound.stop()
                sound.play()
            }
        }
    }

    private func exportCSV() {
        guard let timer = timer else {
            showExportAlert(title: "Error", message: "Timer not available")
            return
        }

        StatisticsExporter.saveCSVToFile(
            dailyHistory: timer.dailyHistory,
            totalSessions: timer.totalWorkSessions
        )
    }

    private func exportPDF(reportType: StatisticsExporter.ReportType) {
        guard let timer = timer else {
            showExportAlert(title: "Error", message: "Timer not available")
            return
        }

        StatisticsExporter.exportToPDF(
            dailyHistory: timer.dailyHistory,
            totalSessions: timer.totalWorkSessions,
            reportType: reportType
        )
    }

    private func showExportAlert(title: String, message: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
}

#Preview {
    SettingsView()
}

