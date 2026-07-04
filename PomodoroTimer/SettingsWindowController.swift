import SwiftUI
import AppKit

class SettingsWindowController: NSObject {
    static let shared = SettingsWindowController()
    private var window: NSWindow?
    var onShow: (() -> Void)?
    weak var timer: PomodoroTimer?

    func show() {
        onShow?()

        if let existingWindow = window {
            existingWindow.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }

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
        NSApp.activate(ignoringOtherApps: true)
    }
}
