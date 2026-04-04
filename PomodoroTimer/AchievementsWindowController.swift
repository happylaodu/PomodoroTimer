import SwiftUI
import AppKit

class AchievementsWindowController: NSObject {
    static let shared = AchievementsWindowController()
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
        guard let timer = timer else { return }

        let achievementsView = AchievementsView(timer: timer)
        let hostingController = NSHostingController(rootView: achievementsView)
        let newWindow = NSWindow(contentViewController: hostingController)
        newWindow.title = NSLocalizedString("Achievements", comment: "")
        newWindow.styleMask = [.titled, .closable, .resizable]
        newWindow.setContentSize(NSSize(width: 900, height: 650))
        newWindow.isReleasedWhenClosed = false
        newWindow.center()

        self.window = newWindow

        newWindow.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}
