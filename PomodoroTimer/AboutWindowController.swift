//
//  AboutWindowController.swift
//  PomodoroTimer
//
//  Created by happylaodu on 2026-03-23.
//

import SwiftUI
import AppKit

class AboutWindowController: NSObject {
    static let shared = AboutWindowController()
    private var window: NSWindow?

    func show() {
        // Close old window if exists
        if let oldWindow = window {
            oldWindow.close()
        }

        // Create new window
        let hostingController = NSHostingController(rootView: AboutView())
        let newWindow = NSWindow(contentViewController: hostingController)
        newWindow.title = NSLocalizedString("About Pomodoro Timer Lite", comment: "About window title")
        newWindow.setContentSize(NSSize(width: 400, height: 500))
        newWindow.styleMask = [.titled, .closable]
        newWindow.isReleasedWhenClosed = false
        newWindow.center()

        self.window = newWindow

        // Show window
        newWindow.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}
