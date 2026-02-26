import SwiftUI
import AppKit

class SettingsWindowController: NSObject {
    static let shared = SettingsWindowController()
    private var window: NSWindow?
    var onShow: (() -> Void)?
    weak var timer: PomodoroTimer?

    func show() {
        // Call the onShow callback to close popover
        onShow?()
        // Close old window if exists
        if let oldWindow = window {
            oldWindow.close()
        }

        // Always create a new window to ensure fresh state
        let hostingController = NSHostingController(rootView: SettingsView(timer: timer))
        let newWindow = NSWindow(contentViewController: hostingController)
        newWindow.title = NSLocalizedString("Settings", comment: "Settings window title")
        newWindow.setContentSize(NSSize(width: 440, height: 780))
        newWindow.styleMask = [.titled, .closable]
        newWindow.isReleasedWhenClosed = false
        newWindow.level = .floating  // Ensure window appears on top
        newWindow.center()

        self.window = newWindow

        // Show immediately to ensure proper window activation
        newWindow.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)

        // Force view refresh after window is shown
        DispatchQueue.main.async {
            hostingController.rootView = SettingsView(timer: self.timer)
        }
    }
}
