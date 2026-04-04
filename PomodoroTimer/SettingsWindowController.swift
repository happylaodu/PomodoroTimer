import SwiftUI
import AppKit

class SettingsWindowController: NSObject {
    static let shared = SettingsWindowController()
    private var window: NSWindow?
    var onShow: (() -> Void)?
    weak var timer: PomodoroTimer?
    private var hasShownOnce = false

    func show() {
        // Call the onShow callback to close popover
        onShow?()

        // Close old window if exists
        if let oldWindow = window {
            oldWindow.close()
            window = nil
        }

        // Only use hide/unhide trick on first show to fix Toggle rendering
        if !hasShownOnce {
            hasShownOnce = true

            // Force app deactivation and reactivation cycle before showing window
            NSApp.hide(nil)

            // Wait briefly for hide to complete, then create and show window
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
                NSApp.unhide(nil)
                NSApp.activate(ignoringOtherApps: true)
                self?.createAndShowWindow()
            }
        } else {
            // Subsequent shows: just create and show normally
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
                NSApp.activate(ignoringOtherApps: true)
                self?.createAndShowWindow()
            }
        }
    }

    private func createAndShowWindow() {
        // Create and show the window
        let hostingController = NSHostingController(rootView: SettingsView(timer: self.timer))
        let newWindow = NSWindow(contentViewController: hostingController)
        newWindow.title = NSLocalizedString("Settings", comment: "Settings window title")
        newWindow.setContentSize(NSSize(width: 440, height: 880))
        newWindow.styleMask = [.titled, .closable]
        newWindow.isReleasedWhenClosed = false
        newWindow.center()

        self.window = newWindow

        newWindow.makeKeyAndOrderFront(nil)
    }
}
