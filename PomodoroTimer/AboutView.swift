//
//  AboutView.swift
//  PomodoroTimer
//
//  Created by happylaodu on 2026-03-23.
//

import SwiftUI

struct AboutView: View {
    private let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Unknown"
    private let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "Unknown"
    private let minSystemVersion = Bundle.main.object(forInfoDictionaryKey: "LSMinimumSystemVersion") as? String ?? "Unknown"

    var body: some View {
        VStack(spacing: 20) {
            // App Icon and Name
            VStack(spacing: 12) {
                if let appIcon = NSImage(named: "AppIcon") {
                    Image(nsImage: appIcon)
                        .resizable()
                        .frame(width: 80, height: 80)
                        .cornerRadius(12)
                } else {
                    Image(systemName: "timer")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.accentColor)
                }

                VStack(spacing: 4) {
                    Text(NSLocalizedString("app.name", comment: "App name"))
                        .font(.title)
                        .bold()

                    Text(String(format: NSLocalizedString("Version %@ (Build %@)", comment: ""), appVersion, buildNumber))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            Divider()

            // App Description
            Text(NSLocalizedString("A simple and elegant Pomodoro timer for macOS. Stay focused, boost productivity, and manage your time effectively with the Pomodoro Technique.", comment: ""))
                .font(.body)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal)

            Divider()

            // Information Section
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(NSLocalizedString("Developer:", comment: ""))
                        .fontWeight(.semibold)
                    Spacer()
                    Text("Zhifeng Du")
                }

                HStack {
                    Text(NSLocalizedString("Copyright:", comment: ""))
                        .fontWeight(.semibold)
                    Spacer()
                    Text("© 2025-2026 Zhifeng Du")
                }

                HStack {
                    Text(NSLocalizedString("System Requirements:", comment: ""))
                        .fontWeight(.semibold)
                    Spacer()
                    Text("macOS \(minSystemVersion)+")
                }
            }
            .font(.caption)
            .padding(.horizontal)

            Divider()

            // Links
            VStack(spacing: 8) {
                Button(action: {
                    if let url = URL(string: "https://apps.apple.com/app/pomodoro-timer-lite/id6748662476") {
                        NSWorkspace.shared.open(url)
                    }
                }) {
                    HStack {
                        Image(systemName: "arrow.down.circle.fill")
                        Text(NSLocalizedString("View on App Store", comment: ""))
                    }
                }
                .buttonStyle(.link)

                Button(action: {
                    if let url = URL(string: "https://apps.apple.com/app/id6748662476?action=write-review") {
                        NSWorkspace.shared.open(url)
                    }
                }) {
                    HStack {
                        Image(systemName: "star.fill")
                        Text(NSLocalizedString("Rate on App Store", comment: ""))
                    }
                }
                .buttonStyle(.link)

                Button(action: {
                    if let url = URL(string: "https://github.com/happylaodu/PomodoroTimer") {
                        NSWorkspace.shared.open(url)
                    }
                }) {
                    HStack {
                        Image(systemName: "chevron.left.forwardslash.chevron.right")
                        Text(NSLocalizedString("Open Source on GitHub", comment: ""))
                    }
                }
                .buttonStyle(.link)
            }
            .font(.caption)

            Spacer()

            // License
            Text(NSLocalizedString("Licensed under MIT License", comment: ""))
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(24)
        .frame(width: 400, height: 500)
    }
}

#Preview {
    AboutView()
}
