# Testing Guide

## Important Notes

⚠️ **The app uses App Sandbox**, so UserDefaults are stored at:
```
~/Library/Containers/com.brightjune.PomodoroTimer/Data/Library/Preferences/com.brightjune.PomodoroTimer.plist
```

**Not** at `~/Library/Preferences/`.

## UserDefaults Backup & Restore (recommended)

### Back up current data

```bash
swift backup_sandbox_defaults.swift
```

This copies the sandboxed plist to `~/.pomodoro_sandbox_backup.plist`.

### Restore backed-up data

```bash
swift restore_sandbox_defaults.swift
```

Restores sandboxed data from the backup file.

### Test workflow

```bash
# 1. Back up before testing
swift backup_sandbox_defaults.swift

# 2. Run tests
xcodebuild test -scheme PomodoroTimer -destination 'platform=macOS'

# 3. Restore after testing
swift restore_sandbox_defaults.swift
```

## Inspect current data

```bash
# View the sandbox plist
plutil -p ~/Library/Containers/com.brightjune.PomodoroTimer/Data/Library/Preferences/com.brightjune.PomodoroTimer.plist

# Or run the diagnostic script
./diagnose.sh
```

## Backup file locations

- **Sandbox backup**: `~/.pomodoro_sandbox_backup.plist` (✅ recommended)
- Legacy backup: `~/.pomodoro_defaults_backup.json` (does not apply to sandboxed data)

## Data fields

- `dailyWorkSessions` — pomodoros completed today
- `weeklyWorkSessions` — current week total (deprecated; now derived from `dailyHistory`)
- `totalWorkSessions` — cumulative total across all history
- `dailyHistory` — per-day history (JSON-encoded `Data`)
- `completedRounds` — rounds completed today
- `lastWorkDate` — date of the last work session

## Cautions

⚠️ **Important**:
1. Running unit tests may clear data — always back up first.
2. The app uses App Sandbox; data lives under the Containers directory.
3. The command-line `UserDefaults.standard` domain differs from the app's sandboxed domain.
