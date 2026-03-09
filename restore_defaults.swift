#!/usr/bin/env swift
import Foundation

// Restore UserDefaults data for Pomodoro Timer
let defaults = UserDefaults.standard
let backupFile = FileManager.default.homeDirectoryForCurrentUser
    .appendingPathComponent(".pomodoro_defaults_backup.json")

guard FileManager.default.fileExists(atPath: backupFile.path) else {
    print("❌ No backup file found at: \(backupFile.path)")
    print("💡 Run backup_defaults.swift first to create a backup")
    exit(1)
}

do {
    let jsonData = try Data(contentsOf: backupFile)
    let backup = try JSONSerialization.jsonObject(with: jsonData) as! [String: Any]

    for (key, value) in backup {
        if let base64String = value as? String,
           let data = Data(base64Encoded: base64String) {
            // Restore Data from base64
            defaults.set(data, forKey: key)
        } else {
            defaults.set(value, forKey: key)
        }
    }

    defaults.synchronize()

    print("✅ Restored backup from: \(backupFile.path)")
    print("📊 Restored keys: \(backup.keys.sorted().joined(separator: ", "))")
} catch {
    print("❌ Restore failed: \(error)")
    exit(1)
}
