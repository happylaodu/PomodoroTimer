//
//  AppDelegate.swift
//  PomodoroTimer
//
//  Created by Steven Du on 2025-07-11.
//

import UserNotifications
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBar: StatusBarController?
    var timer = PomodoroTimer()

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

        // 更新菜单栏显示倒计时
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timer.isRunning {
                let text = self.timeString(from: self.timer.timeRemaining)
                self.statusBar?.updateTitle(text)
                self.statusBar?.updateIcon(for: self.timer.state, isRunning: self.timer.isRunning)
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
    }

    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
    
    
}
