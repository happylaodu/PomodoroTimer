# Simplified Chinese Localization - Testing Guide

## Overview

The Pomodoro Timer Lite app now supports Simplified Chinese (简体中文) localization. All user-facing text will automatically display in Chinese when the system language is set to Chinese.

## What's Localized

All user-facing text in the app has been localized, including:

### Main Window (ContentView)
- Status titles: "Work Time", "Rest Time", "Long Rest Time"
- Statistics: "Today", "This Week", "Total"
- Chart labels: "Date", "Count", "Work Round Count"
- Buttons: "Show Chart", "Reset", "Quit"
- Tooltips: "Switch Current Phase", "Open Settings", etc.

### Settings Panel (SettingsView)
- Section headers: "Auto Start Control", "Duration (Minutes)"
- Toggle labels: "Auto Start Work on First Launch Each Day", etc.
- Stepper labels: "Work Duration", "Short Rest Duration", etc.
- Window title: "Settings"

### Menu Bar & Notifications
- Menu item: "Quit Pomodoro Timer"
- Notification title: "🍅 Pomodoro Session Ended"
- Notification messages: "Rest is over. Time to focus!", "Work completed. Take a break!"

## How to Test

### Method 1: Change System Language (Recommended)

1. **Open System Settings** (System Preferences on older macOS)
2. Go to **General** → **Language & Region**
3. Click the **"+"** button under Preferred Languages
4. Select **简体中文 (Simplified Chinese)**
5. Click **Add**
6. When prompted, choose **"Use 简体中文"** as primary language
7. Your Mac will restart or log out
8. After restart, launch the Pomodoro Timer Lite app
9. All text should now be in Chinese

### Method 2: Force Language in Xcode (For Development)

1. In Xcode, select the PomodoroTimer scheme
2. Click **Edit Scheme** (Product → Scheme → Edit Scheme)
3. Select **Run** in the left sidebar
4. Go to the **Options** tab
5. Under **App Language**, select **Chinese, Simplified**
6. Click **Close**
7. Run the app (Cmd+R)

### Method 3: Launch with Specific Language (Terminal)

```bash
# Launch with Chinese
open -a "Pomodoro Timer Lite" --args -AppleLanguages "(zh-Hans)"

# Launch with English (default)
open -a "Pomodoro Timer Lite" --args -AppleLanguages "(en)"
```

## Verification Checklist

Use this checklist to verify all localizations are working:

### Main Window
- [ ] "Work Time" → "工作时间"
- [ ] "Rest Time" → "休息时间"
- [ ] "Long Rest Time" → "长休息时间"
- [ ] "Today: X 🍅" → "今天：X 🍅"
- [ ] "This Week: X 🍅" → "本周：X 🍅"
- [ ] "Total: X 🍅" → "总计：X 🍅"
- [ ] "Reset" button → "重置"
- [ ] "Quit" button → "退出"

### Settings Panel
- [ ] Window title "Settings" → "设置"
- [ ] "⏱ Auto Start Control" → "⏱ 自动启动控制"
- [ ] "⏲ Duration (Minutes)" → "⏲ 时长（分钟）"
- [ ] "Auto Start Work on First Launch Each Day" → "每天首次启动时自动开始工作"
- [ ] "Work Duration: X" → "工作时长：X"
- [ ] "Enable Long Rest" → "启用长休息"

### Notifications
- [ ] Notification title "🍅 Pomodoro Session Ended" → "🍅 番茄钟结束"
- [ ] "Rest is over. Time to focus!" → "休息结束，开始专注！"
- [ ] "Work completed. Take a break!" → "工作完成，休息一下吧！"

### Menu Bar
- [ ] Right-click menu "Quit Pomodoro Timer" → "退出番茄计时器"

### Chart View
- [ ] X-axis label "Date" → "日期"
- [ ] Y-axis label "Work Round Count" → "工作轮数"

## Common Issues

### Issue: App still shows English text after changing system language

**Solution:**
1. Completely quit the app (right-click in Dock → Quit)
2. Clear app cache: `rm -rf ~/Library/Caches/com.stevendu.PomodoroTimer`
3. Relaunch the app

### Issue: Mixed English and Chinese text

**Solution:**
1. Check that the system language is set to Chinese (Simplified), not Chinese (Traditional)
2. Verify in Terminal:
   ```bash
   defaults read -g AppleLanguages
   ```
   Should show `"zh-Hans"` at the top

### Issue: Date format still in English

**Solution:**
This is intentional. The chart dates use the system locale's date format, which is separate from the app's language. If you want dates in Chinese format as well, change Region to China in System Settings.

## Files Added/Modified

### New Files
- `PomodoroTimer/en.lproj/Localizable.strings` - English strings
- `PomodoroTimer/zh-Hans.lproj/Localizable.strings` - Chinese strings

### Modified Files
- `ContentView.swift` - Updated all text to use `NSLocalizedString`
- `SettingsView.swift` - Updated all text to use `NSLocalizedString`
- `StatusBarController.swift` - Updated menu text
- `PomodoroTimer.swift` - Updated notification text
- `SettingsWindowController.swift` - Updated window title
- `PomodoroTimer.xcodeproj/project.pbxproj` - Added localization files to project

## Next Steps for App Store

To publish the Chinese version on the App Store:

1. **Update App Store Metadata**
   - Add Chinese description (already prepared in `Docs/Growth/01-AppStore-Content.md`)
   - Add Chinese screenshots
   - Add Chinese keywords
   - Add Chinese What's New text

2. **Test on All macOS Versions**
   - Test on macOS 12 Monterey (minimum supported)
   - Test on macOS 13 Ventura
   - Test on macOS 14 Sonoma
   - Test on macOS 15 Sequoia

3. **Submit for Review**
   - Include both English and Chinese in the app submission
   - App Store will automatically show the appropriate language to users

## Implementation Details

The localization uses Apple's standard `.strings` file format with the following structure:

```
/* Comment explaining usage */
"English key" = "Translated text";
```

All UI text uses `NSLocalizedString()` which automatically:
1. Detects the user's preferred language
2. Loads the appropriate `.strings` file
3. Returns the translated text
4. Falls back to English if translation is missing

The system automatically handles:
- Language selection based on user preferences
- Right-to-left text (if needed for other languages)
- Plural forms and string formatting
- Dynamic language switching (when user changes system language)

---

**Created**: 2026-02-07
**Version**: 1.4 (upcoming)
