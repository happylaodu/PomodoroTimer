# Pomodoro Timer - Feature Ideas

## Pending Ideas

### Idea-14: [Feature] iPadOS and iOS Support
**Created**: 2026-02-07

Add support for iPadOS and iOS platforms:
- Adapt UI for iPad and iPhone screens
- Handle platform-specific differences (no menu bar on iOS)
- Consider touch interface adaptations
- Test on different device sizes
- Potentially separate apps or universal binary

### Idea-12: [Research] Focus Mode Integration
**Created**: 2026-01-31

Research the feasibility of integrating with macOS Focus Mode:
- Automatically enable Do Not Disturb during work sessions
- Previous attempts (private APIs, AppleScript, Shortcuts) were unstable or impractical
- Continue exploring alternative implementation approaches
- Possible new directions: System Extensions, Shortcuts.app automation
- Priority: Low (research-oriented, may not be feasible)


### Idea-13: [Improvement] Translate All Chinese Content in Repo to English
**Created**: 2026-02-01

Update all files in the repository that contain Chinese text to use only English:
- Scan through all documentation files in `Docs/` directory
- Translate Chinese content to English while maintaining technical accuracy
- Ensure consistency in terminology and style
- Keep code comments in English (already enforced by global preferences)
- Priority: Medium (important for open source release)


<!-- New ideas will be added here -->

## Completed Ideas

### Idea-10: [Feature] Global Keyboard Shortcuts
**Created**: 2026-01-31
**Completed**: 2026-02-07

Successfully implemented global keyboard shortcuts for controlling the timer from any application:

**What was done:**
1. Created KeyboardShortcutManager class using Carbon Event Manager API:
   - Singleton pattern with weak reference to PomodoroTimer
   - Registered three global hotkeys using Carbon's RegisterEventHotKey
   - Installed event handler to process keyboard events

2. Keyboard shortcuts implemented:
   - Show Window: `Cmd+Shift+T` (⌘⇧T) - Shows main popover, useful when menu bar icon is hard to find
   - Start/Pause: `Cmd+Shift+P` (⌘⇧P)
   - Reset: `Cmd+Shift+R` (⌘⇧R)
   - Switch Mode: `Cmd+Shift+M` (⌘⇧M)

3. Added helper methods to PomodoroTimer.swift:
   - `switchToWork()` - switches to work mode, preserving running state
   - `switchToRest()` - switches to rest mode with proper duration calculation

4. Updated Settings panel:
   - Added "⌨️ Keyboard Shortcuts" section
   - Shows all three shortcuts with symbols (⌘⇧P, ⌘⇧R, ⌘⇧M)
   - Increased Settings window height to 600px

5. Added localization strings:
   - English: "Keyboard Shortcuts", "Start/Pause", "Switch Mode"
   - Chinese: "键盘快捷键", "开始/暂停", "切换模式"

**Implementation details:**
- Uses Carbon Event Manager API for global hotkey registration
- Works from any application when PomodoroTimer is running in background
- Switch Mode preserves timer running state and recalculates duration based on completedRounds
- Event handlers stored in dictionary keyed by hotkey ID
- Automatic cleanup in deinit

**Files created/modified:**
- New: `KeyboardShortcutManager.swift` - Global keyboard shortcut manager
- Modified: `PomodoroTimer.swift` - Added switchToWork() and switchToRest() methods
- Modified: `AppDelegate.swift` - Register shortcuts on app launch
- Modified: `StatusBarController.swift` - Added showPopover() method for keyboard shortcut
- Modified: `SettingsView.swift` - Added keyboard shortcuts section
- Modified: `SettingsWindowController.swift` - Increased window height
- Modified: `en.lproj/Localizable.strings` - Added English strings
- Modified: `zh-Hans.lproj/Localizable.strings` - Added Chinese strings

---

### Idea-11: [Feature] Sound Customization
**Created**: 2026-01-31
**Completed**: 2026-02-07

Successfully implemented sound customization features:

**What was done:**
1. Added Sound Settings section in Settings panel:
   - Toggle to enable/disable sound
   - Dropdown to select notification sound
   - 5 sound options: Ping, Glass, Hero, Tink, Purr

2. Updated PomodoroTimer.swift:
   - Modified playSound() to respect sound settings
   - Added check for soundEnabled preference
   - Modified sendNotification() to conditionally add sound

3. Added localization strings:
   - English: "Enable Sound", "Notification Sound", sound names
   - Chinese: "启用声音", "通知声音", sound names

4. Adjusted Settings window:
   - Increased height to 480px to accommodate new section
   - Sound section placed between Auto Start and Duration sections

**Implementation details:**
- Default sound: Ping
- Default state: Sound enabled (true)
- Uses macOS system sounds (NSSound)
- Preserves existing behavior: plays sound 3 times with 0.5s interval

**Files modified:**
- SettingsView.swift - Added Sound section with toggle and picker
- PomodoroTimer.swift - Updated playSound() and sendNotification()
- SettingsWindowController.swift - Increased window height
- en.lproj/Localizable.strings - Added English strings
- zh-Hans.lproj/Localizable.strings - Added Chinese strings

---

### Idea-15: [Feature] Launch at Login
**Created**: 2026-02-07
**Completed**: 2026-02-07

Successfully implemented "Launch at Login" feature:

**What was done:**
1. Added new Settings section "🚀 Launch" with toggle control
2. Implemented ServiceManagement integration:
   - Added @AppStorage("launchAtLogin") to save user preference
   - Created updateLaunchAtLogin() method to register/unregister
   - Modified AppDelegate to respect saved preference on startup
3. Added localization strings:
   - English: "🚀 Launch", "Launch at Login"
   - Chinese: "🚀 启动", "登录时启动"

**Implementation details:**
- When toggle is ON: calls SMAppService.mainApp.register()
- When toggle is OFF: calls SMAppService.mainApp.unregister()
- AppDelegate checks UserDefaults on startup and applies setting
- Removed unconditional auto-registration

**Files modified:**
- SettingsView.swift - Added Launch section and toggle
- AppDelegate.swift - Changed to conditional registration
- en.lproj/Localizable.strings - Added English strings
- zh-Hans.lproj/Localizable.strings - Added Chinese strings

---

### Idea-9: [Feature] Simplified Chinese Localization
**Created**: 2026-01-31
**Completed**: 2026-02-07

Successfully implemented full Simplified Chinese localization for the app:

**What was done:**
1. Created localization infrastructure:
   - `en.lproj/Localizable.strings` - English base strings (33 strings)
   - `zh-Hans.lproj/Localizable.strings` - Chinese translations

2. Updated all Swift files to use `NSLocalizedString()`:
   - ContentView.swift - Main UI, chart labels, buttons
   - SettingsView.swift - Settings panel text
   - StatusBarController.swift - Menu bar items
   - PomodoroTimer.swift - Notification messages
   - SettingsWindowController.swift - Window titles

3. Configured Xcode project:
   - Added both .lproj folders to project
   - Configured PBXVariantGroup for localization
   - Added zh-Hans to knownRegions
   - Verified build copies both language files to app bundle

**Testing:**
- Build succeeded ✓
- Both en.lproj and zh-Hans.lproj in app bundle ✓
- Created comprehensive testing guide in `Docs/Localization-Testing-Guide.md`

**Next steps (for v1.4 release):**
- Test on all macOS versions (12-15)
- Update App Store with Chinese metadata (description, screenshots, keywords)
- Submit bilingual app to App Store
- Update marketing materials for Chinese market

**Files created/modified:**
- New: `PomodoroTimer/en.lproj/Localizable.strings`
- New: `PomodoroTimer/zh-Hans.lproj/Localizable.strings`
- New: `Docs/Localization-Testing-Guide.md`
- Modified: ContentView.swift, SettingsView.swift, StatusBarController.swift, PomodoroTimer.swift, SettingsWindowController.swift
- Modified: PomodoroTimer.xcodeproj/project.pbxproj

---

### Idea-8: [Research] How to Increase Monthly Downloads
**Created**: 2026-01-31
**Completed**: 2026-01-31

Completed comprehensive growth strategy analysis and execution plan, created the following documents (located in `Docs/Growth/`):

1. **00-README.md** - Overview and navigation
2. **01-AppStore-Content.md** - App Store optimization content (English + Chinese description, keywords, Promotional Text)
3. **02-Version-1.3-Release.md** - v1.3 release checklist and steps
4. **03-Marketing-Plan.md** - Detailed marketing plan (Product Hunt, V2EX, Reddit, Zhihu, Xiaohongshu, etc.)
5. **04-Long-Term-Strategy.md** - 6-month long-term growth strategy and feature roadmap
6. **05-Quick-Actions.md** - Today/this week immediate action checklist
7. **Analytics.md** - Data tracking template

**Key Findings:**
- Current 30-day period only 4 downloads, severely insufficient exposure
- Zero ratings/reviews, lack of social proof
- Main advantages: 1.5MB ultra-lightweight, completely free, open source
- Immediate action: Release v1.3 + App Store optimization + marketing campaign

**Expected Goals:**
- 1 month: 50+ downloads, 10+ ratings
- 3 months: 200-500 downloads/month
- 6 months: Enter organic growth trajectory

---

### Idea-7: [Config] Build and Run App in VS Code
**Created**: 2026-01-31
**Completed**: 2026-01-31

Configured VS Code to support building and running the PomodoroTimer app. Created the following configuration files:
- `.vscode/tasks.json`: Configured build tasks (using xcodebuild) and clean tasks
- `.vscode/launch.json`: Configured debug and regular run launch modes
- `.vscode/settings.json`: Configured Swift and LLDB paths

Usage:
- Build: Cmd+Shift+B or run "Build PomodoroTimer" task
- Run: F5 to start debugging, or select "Run PomodoroTimer (No Debug)" configuration

Recommended VS Code extensions:
- Swift Language (sswg.swift-lang)
- CodeLLDB (vadimcn.vscode-lldb)

---

### Idea-6: [Config] Add GitHub MCP Server
**Created**: 2026-01-31
**Completed**: 2026-01-31

GitHub MCP server should be configured in the project root `.mcp.json` file (not `.claude/settings.local.json`). User chose to configure manually.

---

### Idea-2: [Testing] Verify if Skills Can Be Used as Commands
**Created**: 2026-01-29
**Completed**: 2026-01-31

Verification complete: skills and commands are the same concept. `.md` files in the `.claude/commands/` directory are both commands and skills, callable via `/command-name` or Skill tool. Both project-local and global commands work properly.

---

### Idea-4: [Bug Fix] Fix Settings Window Toggle Graying Out Issue
**Created**: 2026-01-30
**Completed**: 2026-01-31

Fixed the issue where toggles in the Settings window occasionally all turn gray. Modified SettingsWindowController to create a new window instance each time instead of reusing the old one, ensuring SwiftUI view state refreshes correctly.

---

### Idea-3: [Feature] Support Global Parameter for new-idea
**Created**: 2026-01-29
**Completed**: 2026-01-29

The new-idea command defaults to no parameters, but users can optionally add a global parameter. If global is specified, the new idea will be added to the `~/.claude/Ideas.md` file instead of the current project's Ideas.md file.

---

<!-- Completed ideas will be moved here -->

## Rejected Ideas

### Idea-5: [Testing] Verify Disable Notifications During Work Feature
**Created**: 2026-01-31
**Rejection Reason**: macOS does not provide a public API or reliable programmatic way to control Do Not Disturb mode. Attempted solutions include: (1) Shortcuts - requires manual user configuration; (2) AppleScript keyboard simulation - no default Do Not Disturb keyboard shortcut and conflicts with other apps; (3) Private API - violates App Store policies. All solutions are insufficiently stable or practical.

---

### Idea-1: [UX] Access .claude Directory via Symlink in Xcode
**Created**: 2026-01-29
**Rejection Reason**: Xcode does not support displaying symlinks as expandable directories; they appear as files. Other attempted methods (Add Files with folder references) could not find the corresponding option in actual operation.

---

<!-- Rejected ideas will be moved here, including rejection reasons -->

---

**Created**: 2026-01-29
