//
//  PomodoroTimerApp.swift
//  PomodoroTimer
//
//  Created by Steven Du on 2025-07-11.
//

import SwiftUI

@main
struct PomodoroTimerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
                //SettingsView() // 未来添加设置页时用
            }
    }
}
