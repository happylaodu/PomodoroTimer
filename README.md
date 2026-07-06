# 🍅 Pomodoro Timer Lite

[![App Store](https://img.shields.io/badge/App%20Store-Download-blue?logo=apple)](https://apps.apple.com/app/pomodoro-timer-lite/id6748662476)
[![GitHub stars](https://img.shields.io/github/stars/happylaodu/PomodoroTimer?style=social)](https://github.com/happylaodu/PomodoroTimer/stargazers)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-macOS%2013%2B-lightgrey)](https://www.apple.com/macos)

**The lightest Pomodoro timer for macOS menu bar — just 2.2MB!**

A minimal and elegant menu bar Pomodoro timer, built with Swift and SwiftUI. Stay focused, track your productivity, and respect your privacy.

[📥 Download on App Store](https://apps.apple.com/app/pomodoro-timer-lite/id6748662476) | [🐛 Report Issues](https://github.com/happylaodu/PomodoroTimer/issues)

---

## ✨ Features

### 🪶 Ultra-Lightweight
- **Only 2.2MB** — 90% smaller than competitors
- Native Swift & SwiftUI, zero third-party dependencies
- Minimal resource usage

### ⚙️ Fully Customizable
- Adjust work duration (15-90 minutes)
- Configure short rest (3-30 min) and long rest (10-60 min)
- Auto-start work, rest, or next cycle
- Set rounds before long rest
- Launch automatically at login

### ⌨️ Global Keyboard Shortcuts
- Show Window: ⌘⇧T
- Start/Pause: ⌘⇧P
- Reset Timer: ⌘⇧R
- Switch Mode: ⌘⇧M

### 🔔 Sound Notifications
- Choose from 12 built-in sounds
- Preview sounds before selecting
- Option to disable sound completely

### 🏆 Achievement System
- **9 achievement badges** to unlock and collect
- Session-based achievements (1, 10, 50, 100, 500, 1000 sessions)
- Streak-based achievements (7, 30, 100 consecutive days)
- Smart migration analyzes your history and unlocks earned achievements
- Beautiful dual-tab window: Badges + Statistics visualization

### 📊 Track Your Productivity
- Daily, weekly, and total session counters
- 7-day, 30-day, and all-time productivity charts
- Visualize your focus trends and progress

### 🎨 Native macOS Design
- Menu bar integration — no Dock clutter
- Animated tomato icons for work/rest/pause states
- Full dark mode support
- Multi-language support (English & 简体中文)

### 🔒 Privacy-First
- **Zero data collection**
- All data stored locally on your Mac
- No internet connection required
- Completely free, no ads, no subscriptions

---

## 📸 Screenshots

### Achievement System (New in v1.6!)
<p float="left">
  <img src="Docs/Growth/screenshots/1.6/appstore-achievements.png" width="400" alt="Achievements - Badges" />
  <img src="Docs/Growth/screenshots/1.6/appstore-chart.png" width="400" alt="Achievements - Statistics" />
</p>

### Menu Bar & Main Interface
<p float="left">
  <img src="Docs/Growth/screenshots/1.6/appstore-work-time.png" width="300" alt="Work Time" />
  <img src="Docs/Growth/screenshots/1.6/appstore-settings-en.png" width="300" alt="Settings Panel" />
</p>

### PDF Export & Reports
<img src="Docs/Growth/screenshots/1.6/5-pdf-export.png" width="400" alt="PDF Export" />

*Full dark mode support | Achievement tracking | Customizable durations | Professional reports*

## 📥 Installation

### Option 1: Download from App Store (Recommended)

[![Download on App Store](https://tools.applemediaservices.com/api/badges/download-on-the-mac-app-store/black/en-us?size=250x83)](https://apps.apple.com/app/pomodoro-timer-lite/id6748662476)

### Option 2: Build from Source

1. **Clone the repository**:
   ```bash
   git clone https://github.com/happylaodu/PomodoroTimer.git
   cd PomodoroTimer
   ```

2. **Open in Xcode**:
   ```bash
   open PomodoroTimer.xcodeproj
   ```

3. **Build and run** (⌘R)
   - Requires macOS 13.0+ and Xcode 15+

---

## 🎯 Why Pomodoro Timer Lite?

**Problem**: Most Pomodoro apps are bloated (10-50MB), require subscriptions, or collect your data.

**Solution**: A minimal, free, open-source timer that does one thing well — help you focus.

### What Makes It Different?

| Feature | Pomodoro Timer Lite | Other Apps |
|---------|-------------------|------------|
| Size | 2.2MB | 10-50MB |
| Price | Free | $5-15 or subscription |
| Data Collection | Zero | Analytics, cloud sync |
| Achievements | ✅ 9 badges | ❌ No |
| Customization | Full control | Often limited |
| Open Source | ✅ Yes | ❌ No |

---

## 🆕 What's New in v1.6

- 🏆 **Achievement System**: 9 badges to unlock (session-based + streak-based)
- 📊 **Statistics Tab**: Visual charts showing 7-day, 30-day, and all-time trends
- 🎯 **Smart Migration**: Automatically analyzes history and unlocks earned achievements
- ✨ **Enhanced UI**: Achievements at top of settings, dedicated dual-tab window
- 🌍 **Full Bilingual Support**: Achievement names and descriptions in English & Chinese

[View full changelog →](https://github.com/happylaodu/PomodoroTimer/releases)

## 🛠 Tech Stack

- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI
- **Menu Bar**: AppKit (NSStatusItem)
- **Charts**: Charts framework
- **Storage**: UserDefaults (local-only)

---

## 📂 Project Structure

```
PomodoroTimer/
├── PomodoroTimer.swift           # Main timer logic & state management
├── ContentView.swift              # Popup UI (SwiftUI)
├── StatusBarController.swift      # Menu bar integration (AppKit)
├── SettingsView.swift             # Settings panel
├── ChartView.swift                # Productivity charts
├── Achievement.swift              # Achievement data model
├── AchievementManager.swift       # Achievement tracking & unlocking
├── AchievementsView.swift         # Achievement UI (dual-tab window)
├── AchievementsWindowController.swift  # Achievement window management
├── ReviewRequestManager.swift     # Smart review prompts
├── AppDelegate.swift              # App lifecycle & notifications
└── Assets.xcassets/               # Icons and resources
```

---

## 🙌 Contributing

Contributions are welcome! Here's how you can help:

1. **Report bugs** — [Open an issue](https://github.com/happylaodu/PomodoroTimer/issues)
2. **Suggest features** — Share your ideas
3. **Submit PRs** — For major changes, open an issue first to discuss

### Development Setup

1. Fork this repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📊 Roadmap

- [x] Achievement system with gamification (v1.6)
- [ ] Achievement notifications
- [ ] Additional achievements and milestones
- [ ] macOS Focus Mode integration
- [ ] iOS companion app

See [Ideas.md](.claude/Ideas.md) for the full feature backlog.

---

## 🐛 Known Issues

None currently! 🎉

If you encounter any problems, please [open an issue](https://github.com/happylaodu/PomodoroTimer/issues).

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

You're free to:
- ✅ Use commercially
- ✅ Modify
- ✅ Distribute
- ✅ Use privately

---

## 💚 Support

If you find this app helpful:

- ⭐ **Star this repo** on GitHub
- 📝 **Rate it** on the [App Store](https://apps.apple.com/app/pomodoro-timer-lite/id6748662476)
- 🐦 **Share** with friends who need better focus
- ☕ **Buy me a coffee** (just kidding, it's free forever!)

---

## 🍅 Author

**happylaodu** — [GitHub](https://github.com/happylaodu)

Built with ❤️ for the Pomodoro Technique community.

---

## 🔗 Links

- [App Store Listing](https://apps.apple.com/app/pomodoro-timer-lite/id6748662476)
- [Report Issues](https://github.com/happylaodu/PomodoroTimer/issues)
- [Marketing Plan](Docs/Growth/03-Marketing-Plan.md)
- [Long-Term Strategy](Docs/Growth/04-Long-Term-Strategy.md)
