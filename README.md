# 🍅 Pomodoro Timer Lite

[![App Store](https://img.shields.io/badge/App%20Store-Download-blue?logo=apple)](https://apps.apple.com/cn/app/pomodoro-timer-lite/id6748662476)
[![GitHub stars](https://img.shields.io/github/stars/happylaodu/PomodoroTimer?style=social)](https://github.com/happylaodu/PomodoroTimer/stargazers)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-macOS%2013%2B-lightgrey)](https://www.apple.com/macos)

**The lightest Pomodoro timer for macOS menu bar — just 1.5MB!**

A minimal and elegant menu bar Pomodoro timer, built with Swift and SwiftUI. Stay focused, track your productivity, and respect your privacy.

[📥 Download on App Store](https://apps.apple.com/cn/app/pomodoro-timer-lite/id6748662476) | [🐛 Report Issues](https://github.com/happylaodu/PomodoroTimer/issues)

---

## ✨ Features

### 🪶 Ultra-Lightweight
- **Only 1.5MB** — 90% smaller than competitors
- Native Swift & SwiftUI, zero third-party dependencies
- Minimal resource usage

### ⚙️ Fully Customizable (New in v1.3!)
- Adjust work duration (15-90 minutes)
- Configure short rest (3-30 min) and long rest (10-60 min)
- Auto-start work, rest, or next cycle
- Set rounds before long rest

### 📊 Track Your Productivity
- Daily, weekly, and total session counters
- 7-day productivity chart
- Visualize your focus trends

### 🎨 Native macOS Design
- Menu bar integration — no Dock clutter
- Animated tomato icons for work/rest/pause states
- Full dark mode support
- Gentle sound notifications

### 🔒 Privacy-First
- **Zero data collection**
- All data stored locally on your Mac
- No internet connection required
- Completely free, no ads, no subscriptions

---

## 📸 Screenshots

### Menu Bar States
<p float="left">
  <img src="docs/screenshots/menubar-rest.png" width="200" alt="Rest Mode" />
  <img src="docs/screenshots/menubar-work.png" width="200" alt="Work Mode" />
  <img src="docs/screenshots/menubar-active.png" width="200" alt="Active Timer" />
</p>

*Green 🍅 = Rest | Gray 🍅 = Ready | Red 🍅 = Working*

### Main Interface
<p float="left">
  <img src="docs/screenshots/main-interface.png" width="350" alt="Main Interface" />
  <img src="docs/screenshots/chart.png" width="350" alt="7-Day Chart" />
</p>

### Settings Panel
<img src="docs/screenshots/settings.png" width="500" alt="Settings Panel" />

*Full dark mode support with customizable durations and auto-start options*

## 📥 Installation

### Option 1: Download from App Store (Recommended)

[![Download on App Store](https://tools.applemediaservices.com/api/badges/download-on-the-mac-app-store/black/en-us?size=250x83)](https://apps.apple.com/cn/app/pomodoro-timer-lite/id6748662476)

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
| Size | 1.5MB | 10-50MB |
| Price | Free | $5-15 or subscription |
| Data Collection | Zero | Analytics, cloud sync |
| Customization | Full control | Often limited |
| Open Source | ✅ Yes | ❌ No |

---

## 🆕 What's New in v1.3

- ⚙️ **Settings Panel**: Customize all timer durations
- 🔄 **Auto-Start Options**: Seamless workflow automation
- 📊 **Improved Tracking**: Better session statistics
- 🎨 **UI Enhancements**: Smoother animations

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
├── PomodoroTimer.swift      # Main timer logic & state management
├── ContentView.swift         # Popup UI (SwiftUI)
├── StatusBarController.swift # Menu bar integration (AppKit)
├── SettingsView.swift        # Settings panel
├── ChartView.swift           # 7-day productivity chart
├── AppDelegate.swift         # App lifecycle & notifications
└── Assets.xcassets/          # Icons and resources
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

- [ ] Global keyboard shortcuts
- [ ] Sound customization
- [ ] Simplified Chinese localization
- [ ] macOS Focus Mode integration (research)

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
- 📝 **Rate it** on the [App Store](https://apps.apple.com/cn/app/pomodoro-timer-lite/id6748662476)
- 🐦 **Share** with friends who need better focus
- ☕ **Buy me a coffee** (just kidding, it's free forever!)

---

## 🍅 Author

**Steven Du** — [GitHub](https://github.com/happylaodu)

Built with ❤️ for the Pomodoro Technique community.

---

## 🔗 Links

- [App Store Listing](https://apps.apple.com/cn/app/pomodoro-timer-lite/id6748662476)
- [Report Issues](https://github.com/happylaodu/PomodoroTimer/issues)
- [Marketing Plan](Docs/Growth/03-Marketing-Plan.md)
- [Long-Term Strategy](Docs/Growth/04-Long-Term-Strategy.md)
