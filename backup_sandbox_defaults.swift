#!/usr/bin/env swift
import Foundation

// Backup sandboxed UserDefaults for Pomodoro Timer
let bundleID = "com.brightjune.PomodoroTimer"
let sandboxPlist = FileManager.default.homeDirectoryForCurrentUser
    .appendingPathComponent("Library/Containers/\(bundleID)/Data/Library/Preferences/\(bundleID).plist")

let backupFile = FileManager.default.homeDirectoryForCurrentUser
    .appendingPathComponent(".pomodoro_sandbox_backup.plist")

guard FileManager.default.fileExists(atPath: sandboxPlist.path) else {
    print("❌ Sandboxed plist not found at: \(sandboxPlist.path)")
    exit(1)
}

do {
    try FileManager.default.copyItem(at: sandboxPlist, to: backupFile)
    print("✅ Backup saved to: \(backupFile.path)")

    if let plist = NSDictionary(contentsOf: backupFile) {
        let keys = ["dailyWorkSessions", "totalWorkSessions", "completedRounds", "dailyHistory"]
        let backed = keys.filter { plist[$0] != nil }
        print("📊 Backed up keys: \(backed.joined(separator: ", "))")
    }
} catch {
    print("❌ Backup failed: \(error)")
    exit(1)
}
