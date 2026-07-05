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

    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label(NSLocalizedString("General", comment: "Settings tab"), systemImage: "gearshape")
                }

            TimerSettingsView()
                .tabItem {
                    Label(NSLocalizedString("Timer", comment: "Settings tab"), systemImage: "clock")
                }

            SoundSettingsView()
                .tabItem {
                    Label(NSLocalizedString("Sound", comment: "Settings tab"), systemImage: "speaker.wave.2")
                }

            ShortcutsSettingsView()
                .tabItem {
                    Label(NSLocalizedString("Shortcuts", comment: "Settings tab"), systemImage: "keyboard")
                }

            ExportSettingsView(timer: timer)
                .tabItem {
                    Label(NSLocalizedString("Export", comment: "Settings tab"), systemImage: "square.and.arrow.up")
                }
        }
        .padding(.top, 8)
        .frame(minWidth: 450, minHeight: 300, idealHeight: 450)
    }
}

// MARK: - General Settings

struct GeneralSettingsView: View {
    @AppStorage("launchAtLogin") private var launchAtLogin = true
    @AppStorage("autoStartWork") private var autoStartWork = false
    @AppStorage("autoStartRest") private var autoStartRest = false
    @AppStorage("autoStartNextCycle") private var autoStartNextCycle = false

    var body: some View {
        Form {
            Section {
                Toggle(NSLocalizedString("Start automatically when computer starts", comment: ""), isOn: $launchAtLogin)
                    .onChange(of: launchAtLogin) { newValue in
                        updateLaunchAtLogin(enabled: newValue)
                    }
            }

            Section(NSLocalizedString("Auto Start Control", comment: "Settings section")) {
                Toggle(NSLocalizedString("Auto Start Work on First Launch Each Day", comment: ""), isOn: $autoStartWork)
                Toggle(NSLocalizedString("Auto Start Rest After Work", comment: ""), isOn: $autoStartRest)
                Toggle(NSLocalizedString("Auto Start Work After Rest", comment: ""), isOn: $autoStartNextCycle)
            }
        }
        .formStyle(.grouped)
        .padding()
    }

    private func updateLaunchAtLogin(enabled: Bool) {
        do {
            if enabled {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            print("Failed to update launch at login: \(error)")
        }
    }
}

// MARK: - Timer Settings

struct TimerSettingsView: View {
    @AppStorage("workDuration") private var workDuration = 25
    @AppStorage("shortRestDuration") private var shortRestDuration = 5
    @AppStorage("longRestDuration") private var longRestDuration = 15
    @AppStorage("roundsBeforeLongRest") private var roundsBeforeLongRest = 4
    @AppStorage("enableLongRest") private var enableLongRest = true

    var body: some View {
        Form {
            Section(NSLocalizedString("Duration", comment: "Settings section")) {
                DurationField(
                    label: NSLocalizedString("Work Duration", comment: ""),
                    value: $workDuration,
                    range: 15...90,
                    unit: NSLocalizedString("min", comment: "Duration unit")
                )
                DurationField(
                    label: NSLocalizedString("Short Rest Duration", comment: ""),
                    value: $shortRestDuration,
                    range: 3...30,
                    unit: NSLocalizedString("min", comment: "Duration unit")
                )
            }

            Section(NSLocalizedString("Long Rest", comment: "Settings section")) {
                Toggle(NSLocalizedString("Enable Long Rest", comment: ""), isOn: $enableLongRest)
                DurationField(
                    label: NSLocalizedString("Rounds Before Long Rest", comment: ""),
                    value: $roundsBeforeLongRest,
                    range: 2...10,
                    unit: NSLocalizedString("rounds", comment: "Duration unit")
                )
                .disabled(!enableLongRest)
                DurationField(
                    label: NSLocalizedString("Long Rest Duration", comment: ""),
                    value: $longRestDuration,
                    range: 10...60,
                    unit: NSLocalizedString("min", comment: "Duration unit")
                )
                .disabled(!enableLongRest)
            }
        }
        .formStyle(.grouped)
        .padding()
    }
}

struct DurationField: View {
    let label: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    let unit: String

    @State private var textValue: String = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            TextField("", text: $textValue)
                .textFieldStyle(.roundedBorder)
                .frame(width: 65)
                .multilineTextAlignment(.center)
                .focused($isFocused)
                .onSubmit { commit() }
                .onChange(of: isFocused) { focused in
                    if !focused { commit() }
                }
            Stepper("", value: $value, in: range)
                .labelsHidden()
                .onChange(of: value) { newValue in
                    textValue = "\(newValue)"
                }
            Text(unit)
                .foregroundColor(.secondary)
                .fixedSize()
        }
        .onAppear {
            textValue = "\(value)"
        }
    }

    private func commit() {
        if let num = Int(textValue) {
            value = min(max(num, range.lowerBound), range.upperBound)
            textValue = "\(value)"
        } else {
            textValue = "\(value)"
        }
    }
}

// MARK: - Sound Settings

struct SoundSettingsView: View {
    @AppStorage("soundEnabled") private var soundEnabled = true
    @AppStorage("notificationSound") private var notificationSound = "Ping"
    @AppStorage("soundRepeatCount") private var soundRepeatCount = 3

    var body: some View {
        Form {
            Section(NSLocalizedString("Notification", comment: "Settings section")) {
                Toggle(NSLocalizedString("Enable Sound", comment: ""), isOn: $soundEnabled)

                HStack {
                    Picker(NSLocalizedString("Notification Sound", comment: ""), selection: $notificationSound) {
                        Text("Ping").tag("Ping")
                        Text("Glass").tag("Glass")
                        Text("Hero").tag("Hero")
                        Text("Tink").tag("Tink")
                        Text("Purr").tag("Purr")
                        Text("Basso").tag("Basso")
                        Text("Blow").tag("Blow")
                        Text("Bottle").tag("Bottle")
                        Text("Frog").tag("Frog")
                        Text("Funk").tag("Funk")
                        Text("Pop").tag("Pop")
                        Text("Sosumi").tag("Sosumi")
                    }
                    .disabled(!soundEnabled)
                    .onChange(of: notificationSound) { newValue in
                        previewSound(newValue)
                    }

                    Spacer()

                    Button {
                        previewSound(notificationSound)
                    } label: {
                        Image(systemName: "play.circle")
                    }
                    .disabled(!soundEnabled)
                }

                DurationField(
                    label: NSLocalizedString("Sound Repeat Count", comment: ""),
                    value: $soundRepeatCount,
                    range: 1...5,
                    unit: NSLocalizedString("times", comment: "Duration unit")
                )
                .disabled(!soundEnabled)
            }
        }
        .formStyle(.grouped)
        .padding()
    }

    private func previewSound(_ soundName: String) {
        guard soundEnabled else { return }
        guard let sound = NSSound(named: NSSound.Name(soundName)) else { return }

        for i in 0..<soundRepeatCount {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.5) {
                sound.stop()
                sound.play()
            }
        }
    }
}

// MARK: - Shortcuts Settings

struct ShortcutsSettingsView: View {
    var body: some View {
        Form {
            Section(NSLocalizedString("Keyboard Shortcuts", comment: "Settings section")) {
                ShortcutRow(title: NSLocalizedString("Open Settings", comment: ""), shortcut: "⌘⇧,")
                ShortcutRow(title: NSLocalizedString("Switch Mode", comment: ""), shortcut: "⌘⇧M")
                ShortcutRow(title: NSLocalizedString("Start/Pause", comment: ""), shortcut: "⌘⇧P")
                ShortcutRow(title: NSLocalizedString("Reset", comment: ""), shortcut: "⌘⇧R")
                ShortcutRow(title: NSLocalizedString("Show Window", comment: ""), shortcut: "⌘⇧T")
            }

            Section {
                Text(NSLocalizedString("Tip: If you don't see the tomato icon in the menu bar, use ⇧⌘T to show the window and locate the icon. To reposition: hold ⌘ and drag less-used icons to the left (hidden area) to make room for frequently-used apps.", comment: ""))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .formStyle(.grouped)
        .padding()
    }
}

struct ShortcutRow: View {
    let title: String
    let shortcut: String

    private var formattedShortcut: String {
        shortcut.map { String($0) }.joined(separator: " + ")
    }

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(formattedShortcut)
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Export Settings

struct ExportSettingsView: View {
    var timer: PomodoroTimer?

    var body: some View {
        Form {
            Section(NSLocalizedString("Export Data", comment: "Settings section")) {
                Button(NSLocalizedString("Export to CSV", comment: "")) {
                    exportCSV()
                }

                Button(NSLocalizedString("Weekly Report (PDF)", comment: "")) {
                    exportPDF(reportType: .weekly)
                }

                Button(NSLocalizedString("Monthly Report (PDF)", comment: "")) {
                    exportPDF(reportType: .monthly)
                }

                Button(NSLocalizedString("All-Time Report (PDF)", comment: "")) {
                    exportPDF(reportType: .all)
                }
            }
        }
        .formStyle(.grouped)
        .padding()
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

        ReviewRequestManager.shared.checkAndRequestReview(trigger: .statisticsExport)
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

        ReviewRequestManager.shared.checkAndRequestReview(trigger: .statisticsExport)
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
