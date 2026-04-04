//
//  AppDelegate.swift
//  PomodoroTimer
//
//  Created by Steven Du on 2025-07-11.
//

import UserNotifications
import ServiceManagement
import SwiftUI
import Combine

class AppDelegate: NSObject, NSApplicationDelegate, UNUserNotificationCenterDelegate {
    var statusBar: StatusBarController?
    var timer = PomodoroTimer()
    private var achievementObserver: NSObjectProtocol?

    func applicationDidFinishLaunching(_ notification: Notification) {
        let contentView = ContentView(timer: self.timer)
        statusBar = StatusBarController(contentView)

        timer.onUpdateUI = { [weak self] in
            guard let self = self else { return }
            let text = self.timeString(from: self.timer.timeRemaining)
            self.statusBar?.updateTitle(text)
            self.statusBar?.updateIcon(for: self.timer.state, isRunning: self.timer.isRunning)
        }
        self.timer.onUpdateUI?()

        // Set up callback to close popover when Settings window opens
        SettingsWindowController.shared.onShow = { [weak self] in
            self?.statusBar?.closePopover()
        }

        // Pass timer to SettingsWindowController for statistics export
        SettingsWindowController.shared.timer = self.timer

        // Set up callback to close popover when Achievements window opens
        AchievementsWindowController.shared.onShow = { [weak self] in
            self?.statusBar?.closePopover()
        }

        // Pass timer to AchievementsWindowController
        AchievementsWindowController.shared.timer = self.timer

        // Register global keyboard shortcuts
        KeyboardShortcutManager.shared.timer = self.timer
        KeyboardShortcutManager.shared.statusBar = self.statusBar
        KeyboardShortcutManager.shared.registerShortcuts()

        // Set notification center delegate to handle notification taps
        UNUserNotificationCenter.current().delegate = self

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
            if granted {
                print("✅ Notification permission granted")
            } else {
                print("❌ Notification permission denied")
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let window = NSApp.windows.first {
                window.setContentSize(NSSize(width: 280, height: 320))
                window.minSize = NSSize(width: 280, height: 320)
                window.maxSize = NSSize(width: 280, height: 320)
                window.styleMask.remove(.resizable) // 可选：防止用户调整窗口大小
            }
        }

        // Check if this is the first launch
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        if isFirstLaunch {
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")

            // Show popover on first launch to help user find the menu bar icon
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.statusBar?.showPopover()
            }
        }

        // Register/unregister launch at login based on user preference
        // For first launch, launchAtLogin defaults to true
        let launchAtLogin = UserDefaults.standard.object(forKey: "launchAtLogin") as? Bool ?? true
        do {
            if launchAtLogin {
                try SMAppService.mainApp.register()
                print("✅ App registered to launch at login")
            } else {
                try SMAppService.mainApp.unregister()
                print("✅ App unregistered from launch at login")
            }
        } catch {
            print("❌ Failed to update launch at login: \(error)")
        }

        // Set up observer for achievement updates to show badge on status bar
        setupAchievementObserver()
    }

    private func setupAchievementObserver() {
        // Update badge whenever newlyUnlockedAchievements changes
        achievementObserver = NotificationCenter.default.addObserver(
            forName: NSNotification.Name("AchievementUnlocked"),
            object: nil,
            queue: .main
        ) { [weak self] _ in
            let count = AchievementManager.shared.newlyUnlockedAchievements.count
            self?.statusBar?.updateAchievementBadge(count: count)
        }

        // Initial update
        DispatchQueue.main.async { [weak self] in
            let count = AchievementManager.shared.newlyUnlockedAchievements.count
            self?.statusBar?.updateAchievementBadge(count: count)
        }
    }

    deinit {
        if let observer = achievementObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }

    // MARK: - UNUserNotificationCenterDelegate

    /// Handle notification tap - open main window when user taps achievement notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Check if this is an achievement notification
        if response.notification.request.identifier.hasPrefix("achievement_") {
            // Open main popover window
            DispatchQueue.main.async { [weak self] in
                self?.statusBar?.showPopover()
                // Activate app to bring it to front
                NSApp.activate(ignoringOtherApps: true)
            }
        }
        completionHandler()
    }


}
