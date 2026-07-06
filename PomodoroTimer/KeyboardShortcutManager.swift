//
//  KeyboardShortcutManager.swift
//  PomodoroTimer
//
//  Created by happylaodu on 2026-02-07.
//

import Cocoa
import Carbon

class KeyboardShortcutManager {
    static let shared = KeyboardShortcutManager()

    private var eventHandlers: [UInt32: () -> Void] = [:]
    private var eventHandler: EventHandlerRef?
    private var hotKeyRefs: [EventHotKeyRef] = []

    weak var timer: PomodoroTimer?
    weak var statusBar: StatusBarController?

    private init() {}

    func registerShortcuts() {
        // Start/Pause: Cmd+Shift+P
        registerShortcut(
            keyCode: UInt32(kVK_ANSI_P),
            modifiers: UInt32(cmdKey | shiftKey),
            id: 1,
            action: { [weak self] in
                self?.toggleTimer()
            }
        )

        // Reset: Cmd+Shift+R
        registerShortcut(
            keyCode: UInt32(kVK_ANSI_R),
            modifiers: UInt32(cmdKey | shiftKey),
            id: 2,
            action: { [weak self] in
                self?.resetTimer()
            }
        )

        // Switch mode: Cmd+Shift+M
        registerShortcut(
            keyCode: UInt32(kVK_ANSI_M),
            modifiers: UInt32(cmdKey | shiftKey),
            id: 3,
            action: { [weak self] in
                self?.switchMode()
            }
        )

        // Show window: Cmd+Shift+T
        registerShortcut(
            keyCode: UInt32(kVK_ANSI_T),
            modifiers: UInt32(cmdKey | shiftKey),
            id: 4,
            action: { [weak self] in
                self?.showWindow()
            }
        )

        // Settings: Cmd+Shift+,
        registerShortcut(
            keyCode: UInt32(kVK_ANSI_Comma),
            modifiers: UInt32(cmdKey | shiftKey),
            id: 5,
            action: { [weak self] in
                self?.openSettings()
            }
        )

        // Install event handler
        var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
        InstallEventHandler(GetApplicationEventTarget(), { (_, event, userData) -> OSStatus in
            guard let userData = userData else { return OSStatus(eventNotHandledErr) }
            let manager = Unmanaged<KeyboardShortcutManager>.fromOpaque(userData).takeUnretainedValue()

            var hotKeyID = EventHotKeyID()
            GetEventParameter(event, UInt32(kEventParamDirectObject), UInt32(typeEventHotKeyID), nil, MemoryLayout<EventHotKeyID>.size, nil, &hotKeyID)

            manager.eventHandlers[hotKeyID.id]?()
            return noErr
        }, 1, &eventType, Unmanaged.passUnretained(self).toOpaque(), &eventHandler)
    }

    private func registerShortcut(keyCode: UInt32, modifiers: UInt32, id: UInt32, action: @escaping () -> Void) {
        var hotKeyID = EventHotKeyID(signature: OSType(0x484B4559), id: id) // 'HKEY'
        var hotKeyRef: EventHotKeyRef?

        let status = RegisterEventHotKey(keyCode, modifiers, hotKeyID, GetApplicationEventTarget(), 0, &hotKeyRef)

        if status == noErr {
            if let ref = hotKeyRef {
                hotKeyRefs.append(ref)
            }
            eventHandlers[id] = action
            print("✅ Registered keyboard shortcut ID \(id)")
        } else {
            print("❌ Failed to register keyboard shortcut ID \(id): \(status)")
        }
    }

    private func toggleTimer() {
        guard let timer = timer else { return }
        if timer.isRunning {
            timer.pause()
        } else {
            timer.start()
        }
    }

    private func resetTimer() {
        timer?.reset()
    }

    private func switchMode() {
        guard let timer = timer else { return }
        if timer.state == .work {
            timer.switchToRest()
        } else {
            timer.switchToWork()
        }
    }

    private func showWindow() {
        statusBar?.showPopover()
    }

    private func openSettings() {
        SettingsWindowController.shared.show()
    }

    deinit {
        if let eventHandler = eventHandler {
            RemoveEventHandler(eventHandler)
        }
    }
}
