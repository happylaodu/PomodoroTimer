import SwiftUI
import AppKit

class SettingsWindowController: NSObject {
    static let shared = SettingsWindowController()
    private var window: NSWindow?

    func show() {
        // Close old window if exists
        if let oldWindow = window {
            oldWindow.close()
        }

        // Always create a new window to ensure fresh state
        let hostingController = NSHostingController(rootView: SettingsView())
        let newWindow = NSWindow(contentViewController: hostingController)
        newWindow.title = "Settings"
        newWindow.setContentSize(NSSize(width: 440, height: 380))
        newWindow.styleMask = [.titled, .closable]
        newWindow.isReleasedWhenClosed = false
        newWindow.center()
        newWindow.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)

        self.window = newWindow
    }
}
