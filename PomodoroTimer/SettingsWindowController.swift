import SwiftUI
import AppKit

class SettingsWindowController: NSObject {
    static let shared = SettingsWindowController()
    private var window: NSWindow?
    var onShow: (() -> Void)?
    weak var timer: PomodoroTimer?
    private var hasShownOnce = false

    func show() {
        onShow?()

        if let existingWindow = window {
            existingWindow.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
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
        let hostingController = NSHostingController(rootView: SettingsView(timer: self.timer))
        let newWindow = NSWindow(contentViewController: hostingController)
        newWindow.title = NSLocalizedString("Settings", comment: "Settings window title")
        newWindow.styleMask = [.titled, .closable, .resizable]
        newWindow.isReleasedWhenClosed = false
        newWindow.setContentSize(NSSize(width: 450, height: 450))
        newWindow.minSize = NSSize(width: 450, height: 300)
        newWindow.maxSize = NSSize(width: 450, height: CGFloat.greatestFiniteMagnitude)
        newWindow.center()

        self.window = newWindow

        newWindow.makeKeyAndOrderFront(nil)
    }
}
