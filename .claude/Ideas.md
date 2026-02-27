# Pomodoro Timer - Feature Ideas

## Pending Ideas

### Idea-17: [Feature] Enhanced Chart Time Range Options
**Created**: 2026-02-26

Add flexible time range selection to the usage statistics chart:
- Currently: Fixed 7-day view only
- Proposed: Three view options for users to toggle between
  - **Last 7 Days**: Daily bars (current implementation)
  - **Last 30 Days**: Daily bars showing one month of data
  - **All-Time Overview**: Weekly aggregated bars (each bar = 1 week total)
- UI: Add segmented control or dropdown to switch between views
- Maintain consistent chart styling and layout
- Preserve existing 7-day default view for backward compatibility
- Priority: Medium (enhances data visibility for long-term users)

### Idea-15: [Feature] Achievement System
**Created**: 2026-02-24

Implement gamification through achievement badges to increase user engagement:
- 7-day streak achievement → unlock special badge
- 100 Pomodoro sessions milestone → unlock special icon
- Other achievements: first session, 30-day streak, 500 sessions, etc.
- Display achievements in app (Settings or dedicated view)
- Local storage for achievement data
- Increases motivation and retention
- Priority: Medium (planned for v1.5)

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

### Idea-18: [Feature] Add Charts to PDF Reports
**Created**: 2026-02-26
**Completed**: 2026-02-27

Successfully implemented comprehensive chart visualization in PDF reports with both daily and weekly views:

**What was done:**

1. Daily bar chart rendering:
   - Created `drawBarChart()` method using Core Graphics
   - Chart displays sessions per day matching the daily breakdown table data
   - Supports all report types: Weekly (7 days), Monthly (30 days), and All-Time
   - Chart positioned between summary statistics and daily breakdown table
   - Blue-colored bars matching in-app chart design

2. Weekly overview chart (Monthly/All-Time reports with >7 days):
   - Automatic weekly data aggregation (week starts on Sunday)
   - Green-colored bars to differentiate from daily chart
   - Week labels show start date (MM/DD format)
   - Helps visualize week-to-week trends

3. Chart visual features:
   - Y-axis with grid lines and labels showing session counts
   - X-axis with rotated date labels at -45 degrees for readability
   - Value labels on top of each bar for exact counts
   - Professional appearance with proper margins and spacing
   - Optimized label positioning to avoid overlap

4. PDF pagination improvements:
   - Multi-page support for complete data display
   - Smart page breaks to avoid orphaned table headers
   - Automatic new page creation when space is insufficient
   - All data rows guaranteed to be included (no truncation)

5. Core Graphics implementation:
   - PDF coordinate system handling (bottom-left origin)
   - Automatic scaling based on maximum value in data
   - Dynamic bar width calculation based on data count
   - Axes and grid lines for better readability
   - Text rendering with proper fonts and positioning

**Implementation details:**
- Weekly aggregation: `aggregateDataByWeek()` groups data by week (Sunday-Saturday)
- Bar colors: Blue for daily (#0079FF), Green for weekly (#34C759)
- Chart dimensions: 180pt height, page width minus margins
- Label offset: 4pt right shift for center alignment
- Pagination threshold: 120pt remaining space for table header

**Files modified:**
- Modified: `StatisticsExporter.swift` - Added chart rendering, pagination, and weekly aggregation

**Testing:**
- Build succeeded ✓
- Daily charts render correctly in all report types ✓
- Weekly charts appear only when appropriate ✓
- Multi-page PDFs generated correctly ✓
- Label alignment optimized ✓

**User benefits:**
- Visual representation of productivity trends (daily and weekly)
- Easier identification of patterns and peaks across different time scales
- More valuable and professional PDF reports
- Complete data visibility without truncation
- Better understanding of work session distribution over time

---

### Idea-16: [Feature] Statistics Export
**Created**: 2026-02-24
**Completed**: 2026-02-26

Successfully implemented comprehensive statistics export functionality with CSV and PDF report generation:

**What was done:**

1. Created StatisticsExporter class with export capabilities:
   - CSV export: Date, Sessions, Cumulative Total columns
   - PDF export: Professional reports with summary statistics
   - Support for Weekly (last 7 days), Monthly (last 30 days), and All-Time reports
   - Uses macOS NSSavePanel for user-friendly file saving

2. Added Statistics Export section to Settings:
   - "Export to CSV" button - exports all historical data to spreadsheet format
   - "Weekly Report (PDF)" button - generates PDF report for last 7 days
   - "Monthly Report (PDF)" button - generates PDF report for last 30 days
   - "All-Time Report (PDF)" button - generates comprehensive PDF report

3. PDF report features:
   - Professional layout with title, date, and summary section
   - Summary statistics: total sessions, days tracked, average per day, most productive day
   - Daily breakdown table with dates and session counts
   - Uses Core Graphics for proper PDF rendering on macOS
   - Automatic file naming with date stamp

4. Updated Settings window:
   - Increased height to 780px to accommodate new section
   - Export section placed before Keyboard Shortcuts
   - All buttons use bordered style for consistency

5. Added localization strings:
   - English: "📊 Statistics Export", "Export to CSV", "Weekly Report (PDF)", etc.
   - Chinese: "📊 统计数据导出", "导出为 CSV", "每周报告（PDF）", etc.

6. Architecture improvements:
   - SettingsView now accepts optional PomodoroTimer parameter
   - SettingsWindowController stores weak reference to timer
   - AppDelegate passes timer to SettingsWindowController on launch
   - Proper separation of concerns between UI and export logic

**Implementation details:**
- CSV format: Simple 3-column format (Date, Sessions, Cumulative Total)
- PDF generation: Uses CGContext and CGDataConsumer for macOS compatibility
- Report filtering: Calendar-based date filtering for weekly/monthly reports
- Statistics calculation: Total sessions, average, maximum, day count
- Error handling: Alert dialogs for export failures
- File naming: Automatic naming with report type and date

**Files created/modified:**
- New: `StatisticsExporter.swift` - Export functionality
- Modified: `SettingsView.swift` - Added export UI section and export methods
- Modified: `SettingsWindowController.swift` - Pass timer instance to SettingsView
- Modified: `AppDelegate.swift` - Set timer reference in SettingsWindowController
- Modified: `en.lproj/Localizable.strings` - Added English strings
- Modified: `zh-Hans.lproj/Localizable.strings` - Added Chinese strings

**Testing:**
- Build succeeded ✓
- All files properly integrated into Xcode project ✓

**Next steps:**
- User testing of export functionality
- Consider adding email export option in future version
- Consider adding chart images to PDF reports

---

### Idea-12: [Research] Focus Mode Integration
**Created**: 2026-01-31
**Completed**: 2026-02-24

Successfully completed comprehensive research on macOS Focus Mode integration feasibility:

**Research findings**:
1. **No official API exists** for programmatically controlling Focus Mode (enable/disable)
2. **Available APIs are read-only**:
   - `INFocusStatusCenter` - Can READ Focus status (requires Communication Notifications entitlement)
   - Focus Filters API - Can REACT to Focus changes and filter app content
   - Cannot programmatically enable/disable Focus Mode

3. **Workarounds investigated**:
   - Shortcuts automation: Requires manual user setup, not seamless
   - Reading system files: Violates App Store sandboxing policies
   - AppleScript/UI automation: Unreliable and fragile
   - Private APIs: Violates App Store policies
   - System Extensions: Not applicable to Focus Mode control

4. **App Store compliance**: All workarounds violate App Store policies or require impractical user setup

**Recommendation**: **Not feasible** for App Store distribution

**Alternatives documented**:
1. User education - Guide users to set up native macOS Focus automation
2. In-app notification muting - Control only PomodoroTimer's notifications
3. Optional Shortcuts integration for power users

**Testing performed**:
1. ✅ Shortcuts automation - VERIFIED WORKING:
   - Created "Enable Do Not Disturb" and "Disable Do Not Disturb" shortcuts
   - Both execute successfully via `shortcuts run "<name>"`
   - Technically viable but requires manual user setup

2. ⚠️ INFocusStatusCenter API - TESTED BUT NOT VIABLE:
   - Added `NSFocusStatusUsageDescription` to Info.plist
   - Authorization granted (status = 3)
   - Error: `DNDErrorDomain Code=1004 "App is missing Communication Notifications entitlement"`
   - Requires special entitlement only granted to communication apps
   - App Store rejection risk: HIGH

**Deliverable**:
- Created comprehensive research document: `Docs/Focus-Mode-Integration-Research.md`
- Documented all findings, API examples, workarounds, and alternatives
- Included real-world test results and verification data
- Included references to official Apple documentation and community solutions

**Conclusion**: Feature will not be implemented due to lack of official API support and Communication Notifications entitlement requirement. Recommended alternatives (user education, in-app muting) provide better user experience while remaining App Store compliant.

---

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

## Deferred to v2.0

### Idea-14: [Feature] iPadOS and iOS Support
**Created**: 2026-02-07
**Deferred**: 2026-02-19
**Reason**: Too large scope for v1.5. Should focus on macOS growth and user validation first. iOS support requires major UI/UX redesign (no menu bar, touch interface) and should be considered for v2.0 major release when macOS version has proven product-market fit (500-1000+ monthly downloads).

Original scope:
- Adapt UI for iPad and iPhone screens
- Handle platform-specific differences (no menu bar on iOS)
- Consider touch interface adaptations
- Test on different device sizes
- Potentially separate apps or universal binary

---

**Created**: 2026-01-29
