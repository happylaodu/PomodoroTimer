//
//  StatusBarController.swift
//  PomodoroTimer
//
//  Created by happylaodu on 2025-07-11.
//


import AppKit
import SwiftUI

class StatusBarController {
    private var statusItem: NSStatusItem
    private var popover: NSPopover
    private var rightClickMonitor: Any?
    private var eventMonitor: Any?
    private var badgeView: NSView?

    init(_ contentView: some View) {
        popover = NSPopover()
        popover.contentSize = NSSize(width: 250, height: 200)
        popover.behavior = .transient
        popover.animates = true
        popover.contentViewController = NSViewController()
        popover.contentViewController?.view = NSHostingView(rootView: contentView)

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            if let image = NSImage(named: "tomato_red") {
                button.image = image
                button.image?.isTemplate = false
            }
            button.action = #selector(togglePopover(_:))
            button.target = self
        }
        // Create right-click menu (or long-press menu)
        // statusItem.menu = menu

        rightClickMonitor = NSEvent.addLocalMonitorForEvents(matching: [.rightMouseDown]) { [weak self] event in
            guard let self = self,
                  let button = self.statusItem.button,
                  let _ = button.window else {
                return event
            }

            let location = button.convert(event.locationInWindow, from: nil)
            if button.bounds.contains(location) {
                let menu = NSMenu()

                // Add "About Pomodoro Timer Lite" menu item
                let aboutItem = NSMenuItem(title: NSLocalizedString("About Pomodoro Timer Lite", comment: ""), action: #selector(self.showAbout), keyEquivalent: "")
                aboutItem.target = self
                menu.addItem(aboutItem)

                // Add separator
                menu.addItem(NSMenuItem.separator())

                #if DEBUG
                // Add "Request Review (Debug)" menu item - only visible in debug builds
                let reviewItem = NSMenuItem(title: "Request Review (Debug)", action: #selector(self.requestReviewDebug), keyEquivalent: "")
                reviewItem.target = self
                menu.addItem(reviewItem)

                // Add "Test Achievement Unlock (Debug)" menu item - only visible in debug builds
                let achievementItem = NSMenuItem(title: "Test Achievement Unlock (Debug)", action: #selector(self.testAchievementUnlock), keyEquivalent: "")
                achievementItem.target = self
                menu.addItem(achievementItem)

                // Add separator
                menu.addItem(NSMenuItem.separator())
                #endif

                // Add "Quit" menu item
                let quitItem = NSMenuItem(title: NSLocalizedString("Quit Pomodoro Timer Lite", comment: ""), action: #selector(self.quitApp), keyEquivalent: "q")
                quitItem.target = self
                menu.addItem(quitItem)

                NSMenu.popUpContextMenu(menu, with: event, for: button)
                return nil // Consume event
            }

            return event
        }
    }

    deinit {
        if let monitor = rightClickMonitor {
            NSEvent.removeMonitor(monitor)
        }
        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
        }
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        guard let button = statusItem.button else { return }

        if popover.isShown {
            popover.performClose(sender)
            if let monitor = eventMonitor {
                NSEvent.removeMonitor(monitor)
                eventMonitor = nil
            }
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)

            // Add global left-click event monitor to close popover
            eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] _ in
                self?.popover.performClose(nil)
                if let monitor = self?.eventMonitor {
                    NSEvent.removeMonitor(monitor)
                    self?.eventMonitor = nil
                }
            }
        }
    }
    
    @objc func showAbout() {
        AboutWindowController.shared.show()
    }

    #if DEBUG
    @objc func requestReviewDebug() {
        print("🔧 Debug: Manually triggering review request...")
        ReviewRequestManager.shared.manualRequestReview()
    }

    @objc func testAchievementUnlock() {
        print("🔧 Debug: Testing achievement unlock...")
        AchievementManager.shared.testUnlockNextAchievement()
    }
    #endif

    @objc func quitApp() {
        NSApp.terminate(nil)
    }

    func closePopover() {
        if popover.isShown {
            popover.performClose(nil)
            if let monitor = eventMonitor {
                NSEvent.removeMonitor(monitor)
                eventMonitor = nil
            }
        }
    }

    /// Show popover (for keyboard shortcut)
    func showPopover() {
        guard let button = statusItem.button else { return }

        if !popover.isShown {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)

            // Add global event monitor to close popover
            eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] _ in
                self?.popover.performClose(nil)
                if let monitor = self?.eventMonitor {
                    NSEvent.removeMonitor(monitor)
                    self?.eventMonitor = nil
                }
            }
        }

        // Activate app to bring it to front
        NSApp.activate(ignoringOtherApps: true)
    }

    /// Optional: update menu bar text, e.g. to display current countdown
    func updateTitle(_ text: String) {
        if let button = statusItem.button {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: NSFont.monospacedDigitSystemFont(ofSize: NSFont.systemFontSize, weight: .regular)
            ]
            button.attributedTitle = NSAttributedString(string: text, attributes: attributes)
        }
    }
    
    func updateIcon(for state: PomodoroTimer.State, isRunning: Bool) {
        let iconName: String

        switch (state, isRunning) {
        case (.work, true): iconName = "tomato_red"
        case (.rest, true): iconName = "tomato_green"
        case (_, false): iconName = "tomato_gray"
        case (.stopped, true):iconName = "tomato_gray"
        }

        statusItem.button?.image = NSImage(named: iconName)
    }

    /// Update achievement badge on status bar
    func updateAchievementBadge(count: Int) {
        guard let button = statusItem.button else { return }

        // Remove existing badge if any
        badgeView?.removeFromSuperview()
        badgeView = nil

        guard count > 0 else { return }

        // Create small badge dot - position at top-right corner (avoid going out of bounds)
        let badgeSize: CGFloat = 8
        let badge = NSView(frame: NSRect(x: button.bounds.width - badgeSize - 2, y: button.bounds.height - badgeSize - 13, width: badgeSize, height: badgeSize))

        // Add red circle background
        let circleLayer = CAShapeLayer()
        circleLayer.path = CGPath(ellipseIn: badge.bounds, transform: nil)
        circleLayer.fillColor = NSColor.systemRed.cgColor
        badge.layer = CALayer()
        badge.wantsLayer = true
        badge.layer?.addSublayer(circleLayer)

        button.addSubview(badge)
        badgeView = badge
    }
}
