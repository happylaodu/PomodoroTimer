//
//  StatusBarController.swift
//  PomodoroTimer
//
//  Created by Steven Du on 2025-07-11.
//


import AppKit
import SwiftUI

class StatusBarController {
    private var statusItem: NSStatusItem
    private var popover: NSPopover
    private var rightClickMonitor: Any?
    private var eventMonitor: Any?

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
        // 创建右键菜单（或长按菜单）
        // statusItem.menu = menu

        rightClickMonitor = NSEvent.addLocalMonitorForEvents(matching: [.rightMouseDown]) { [weak self] event in
            guard let self = self,
                  let button = self.statusItem.button,
                  let window = button.window else {
                return event
            }

            let location = button.convert(event.locationInWindow, from: nil)
            if button.bounds.contains(location) {
                let menu = NSMenu()
                menu.addItem(NSMenuItem(title: NSLocalizedString("Quit Pomodoro Timer", comment: ""), action: #selector(self.quitApp), keyEquivalent: "q"))
                menu.items.first?.target = self
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

    /// 可选：你可以更新菜单栏的文字，比如显示当前倒计时
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
}
