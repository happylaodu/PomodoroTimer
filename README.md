# 🍅 PomodoroTimer

A minimal and elegant **macOS menu bar Pomodoro Timer**, built with Swift and SwiftUI using native AppKit integration.

## ✨ Features

- ⏱ Simple Pomodoro logic (25/5 cycle)
- 🌗 Native macOS menu bar app (no Dock, no window clutter)
- 🍅 Colored tomato icons for work, rest, and pause
- 🔔 Notification alerts with sound
- 💾 Auto-save & restore session state
- 🧠 Pause/resume/reset support
- 🧩 Lightweight, distraction-free UI
- 🧘‍♀️ Auto-close popover on outside click
- 🔐 Signed and `.dmg`-ready for distribution

## 📸 Screenshots

<!-- You can drag screenshots here once available -->

## 🚀 Getting Started

1. Clone the repo:
   ```bash
   git clone https://github.com/yourname/PomodoroTimer.git
   cd PomodoroTimer
   ```

2. Open in Xcode:
   ```
   open PomodoroTimer.xcodeproj
   ```

3. Build and run the app (macOS 13+ recommended).

## 🔧 Project Structure

- `PomodoroTimer.swift` — main timer logic
- `ContentView.swift` — popup UI
- `StatusBarController.swift` — menu bar integration
- `AppDelegate.swift` — lifecycle, notification setup
- `Assets.xcassets` — tomato icons and app icons

## 📦 Distribution

This app supports:

- ✅ Hidden Dock icon (`LSUIElement`)
- ✅ Code signing
- ✅ Custom `.dmg` creation

## 🛠️ Requirements

- macOS 13.0+
- Xcode 15+
- Swift 5.9+

## 🙌 Contributing

Pull requests are welcome. For major changes, please open an issue first.

## 📄 License

MIT

## 🍅 Author

[Steven Du](https://github.com/happylaodu)
