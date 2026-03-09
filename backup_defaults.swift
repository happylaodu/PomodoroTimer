#!/usr/bin/env swift
import Foundation

// Backup UserDefaults data for Pomodoro Timer
let defaults = UserDefaults.standard
let backupFile = FileManager.default.homeDirectoryForCurrentUser
    .appendingPathComponent(".pomodoro_defaults_backup.json")

let keys = ["dailyWorkSessions", "totalWorkSessions", "lastWorkDate", "dailyHistory", "completedRounds"]

var backup: [String: Any] = [:]

for key in keys {
    if let value = defaults.object(forKey: key) {
        if let data = value as? Data {
            // Convert Data to base64 for JSON serialization
            backup[key] = data.base64EncodedString()
        } else {
            backup[key] = value
        }
    }
}

do {
    let jsonData = try JSONSerialization.data(withJSONObject: backup, options: .prettyPrinted)
    try jsonData.write(to: backupFile)
    print("✅ Backup saved to: \(backupFile.path)")
    print("📊 Backed up keys: \(backup.keys.sorted().joined(separator: ", "))")
} catch {
    print("❌ Backup failed: \(error)")
    exit(1)
}
