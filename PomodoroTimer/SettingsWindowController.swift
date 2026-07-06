import SwiftUI
import AppKit

class SettingsWindowController: NSObject {
    static let shared = SettingsWindowController()
    private var window: NSWindow?
    var onShow: (() -> Void)?
    weak var timer: PomodoroTimer?

    func show() {
        onShow?()

        // Always destroy and recreate. Reusing an NSHostingController across
        // shows does not re-render controlActiveState reliably when the window
        // is re-shown from an inactive app, so Toggles stay grayed.
        if let oldWindow = window {
            oldWindow.close()
            window = nil
        }

        if !NSApp.isActive {
            // SwiftUI mounts Toggles in disabled color if the hosting window
            // never becomes key. Force a full hide/activate cycle so the new
            // window transitions to key/main after mount.
            NSApp.hide(nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
                NSApp.unhide(nil)
                NSApp.activate(ignoringOtherApps: true)
                self?.createAndShowWindow()
            }
        } else {
            createAndShowWindow()
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
