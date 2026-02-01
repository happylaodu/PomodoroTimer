# Pomodoro Timer - Feature Ideas

## Pending Ideas

### Idea-12: [Research] Focus Mode Integration
**Created**: 2026-01-31

Research the feasibility of integrating with macOS Focus Mode:
- Automatically enable Do Not Disturb during work sessions
- Previous attempts (private APIs, AppleScript, Shortcuts) were unstable or impractical
- Continue exploring alternative implementation approaches
- Possible new directions: System Extensions, Shortcuts.app automation
- Priority: Low (research-oriented, may not be feasible)

### Idea-11: [Feature] Sound Customization
**Created**: 2026-01-31

Add sound customization features:
- 3-5 notification sound options
- Option to disable sound
- Volume control (optional)
- Reference TimeMate's sound design
- Priority: Medium (v1.4 feature)

### Idea-10: [Feature] Global Keyboard Shortcuts
**Created**: 2026-01-31

Add global keyboard shortcut support, allowing users to control the Pomodoro timer from any application:
- Start/Pause: `Cmd+Shift+P`
- Reset: `Cmd+Shift+R`
- Switch mode: `Cmd+Shift+M`
- Reference Pommie's keyboard shortcut implementation
- Priority: High (v1.4 feature)

### Idea-9: [Feature] Simplified Chinese Localization
**Created**: 2026-01-31

Fully localize the app to Simplified Chinese, including:
- All in-app UI text translation (SwiftUI strings)
- Chinese version of App Store page (partial content already in `Docs/Growth/01-AppStore-Content.md`)
- Utilize prepared Chinese What's New content
- Estimated time: 1-2 weeks
- Priority: High (top priority for v1.4)

<!-- New ideas will be added here -->

## Completed Ideas

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
