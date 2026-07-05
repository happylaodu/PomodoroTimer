# AGENTS.md

## Project Overview

macOS menu bar Pomodoro timer app (Swift/SwiftUI). Runs as LSUIElement (no Dock icon), stays in system menu bar. App Store published under bundle ID `com.brightjune.PomodoroTimer`.

## Build & Run

```bash
# Build and run in Xcode (primary workflow)
open PomodoroTimer.xcodeproj
# Then ⌘R in Xcode

# Build from CLI
xcodebuild -scheme PomodoroTimer -destination 'platform=macOS' build

# Run tests (⚠️ may clear UserDefaults - backup first!)
swift backup_sandbox_defaults.swift
xcodebuild test -scheme PomodoroTimer -destination 'platform=macOS'
swift restore_sandbox_defaults.swift

# Increment build number
./increment-build.sh
```

## Architecture

Single-target Xcode project (no SPM, no CocoaPods). All source in `PomodoroTimer/` directory.

**Entry point**: `PomodoroTimerApp.swift` → uses `@NSApplicationDelegateAdaptor(AppDelegate.self)` to hand off to AppKit-based `AppDelegate`.

**Core flow**:
- `AppDelegate` creates `PomodoroTimer` (ObservableObject) and `StatusBarController`
- `StatusBarController` manages NSStatusItem (menu bar icon) + NSPopover with `ContentView`
- `PomodoroTimer.swift` contains ALL business logic: timer, state machine, stats, persistence
- Settings/Achievements use singleton window controllers (`SettingsWindowController.shared`, `AchievementsWindowController.shared`)

**Key singletons**: `KeyboardShortcutManager.shared`, `AchievementManager.shared`, `SettingsWindowController.shared`, `AchievementsWindowController.shared`

## Data Storage (Critical)

App uses **App Sandbox**. UserDefaults are NOT at `~/Library/Preferences/` — they're at:
```
~/Library/Containers/com.brightjune.PomodoroTimer/Data/Library/Preferences/com.brightjune.PomodoroTimer.plist
```

**Never** use `defaults delete/write` CLI commands — they target the wrong domain. Use the provided Swift scripts:
```bash
swift backup_sandbox_defaults.swift    # backup to ~/.pomodoro_sandbox_backup.plist
swift restore_sandbox_defaults.swift   # restore from backup
```

To inspect current data:
```bash
plutil -p ~/Library/Containers/com.brightjune.PomodoroTimer/Data/Library/Preferences/com.brightjune.PomodoroTimer.plist
```

## Localization

Bilingual: English + Simplified Chinese. Strings in `PomodoroTimer/en.lproj/Localizable.strings` and `zh-Hans.lproj/Localizable.strings`. Use `NSLocalizedString` for all user-facing text.

When adding new strings: add to BOTH `.lproj/Localizable.strings` files.

## App Store Submission Rules

- **No emoji** in App Store metadata (release notes, description, promotional text). Use `[Section]` or `【标题】` markers instead.
- Emoji are fine for GitHub releases, in-app content, and docs.
- Use installed size (not download size) for marketing claims. Check via Xcode Organizer → Archives.

## Adding Files to Xcode Project

This is a plain `.xcodeproj` — new files must be added to the Xcode project manually or via `add_file_to_project.sh`. Files not in the Xcode project won't compile.

## Version Management

- `MARKETING_VERSION` and `CURRENT_PROJECT_VERSION` in `project.pbxproj`
- `CFBundleShortVersionString` and `CFBundleVersion` in `PomodoroTimer/Info.plist`
- Use `./increment-build.sh` to bump build number

## Testing Notes

- Tests use Swift Testing framework (`@Test`, `#expect`), not XCTest
- Tests operate on `UserDefaults.standard` which is the **non-sandboxed** domain — test data won't affect the running app
- Always backup before running tests (they clear UserDefaults keys)
- Test file: `PomodoroTimerTests/PomodoroTimerTests.swift`

## Existing Documentation

- `.claude/project_context.md` — detailed architecture, data flow, known bugs
- `.claude/Common-Mistakes.md` — lessons learned (App Store metadata, size claims, data handling)
- `.claude/Ideas.md` — feature backlog
- `TESTING.md` — backup/restore workflow for sandboxed data
