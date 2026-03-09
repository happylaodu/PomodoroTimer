#!/usr/bin/env swift
import Foundation

// Restore sandboxed UserDefaults for Pomodoro Timer
let bundleID = "com.brightjune.PomodoroTimer"
let sandboxPlist = FileManager.default.homeDirectoryForCurrentUser
    .appendingPathComponent("Library/Containers/\(bundleID)/Data/Library/Preferences/\(bundleID).plist")

let backupFile = FileManager.default.homeDirectoryForCurrentUser
    .appendingPathComponent(".pomodoro_sandbox_backup.plist")

guard FileManager.default.fileExists(atPath: backupFile.path) else {
    print("❌ No backup file found at: \(backupFile.path)")
    print("💡 Run backup_sandbox_defaults.swift first")
    exit(1)
}

do {
    // Remove existing plist
    if FileManager.default.fileExists(atPath: sandboxPlist.path) {
        try FileManager.default.removeItem(at: sandboxPlist)
    }

    // Copy backup
    try FileManager.default.copyItem(at: backupFile, to: sandboxPlist)
    print("✅ Restored backup from: \(backupFile.path)")

    if let plist = NSDictionary(contentsOf: sandboxPlist) {
        let keys = ["dailyWorkSessions", "totalWorkSessions", "completedRounds", "dailyHistory"]
        let restored = keys.filter { plist[$0] != nil }
        print("📊 Restored keys: \(restored.joined(separator: ", "))")
    }

    // Force reload
    let task = Process()
    task.launchPath = "/usr/bin/killall"
    task.arguments = ["-u", NSUserName(), "cfprefsd"]
    task.launch()
    task.waitUntilExit()

    print("🔄 Forced preferences reload")
} catch {
    print("❌ Restore failed: \(error)")
    exit(1)
}
