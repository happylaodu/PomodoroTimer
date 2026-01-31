# 番茄计时器项目上下文

## 项目概述

**PomodoroTimer** 是一个轻量级的 macOS 菜单栏番茄钟应用，使用 SwiftUI 构建。应用以 LSUIElement 方式运行（无 Dock 图标），常驻系统菜单栏，为用户提供简洁高效的时间管理工具。

**版本**: 1.2 (Build 6)
**最低系统要求**: macOS 15.5
**Bundle ID**: com.brightjune.PomodoroTimer
**分类**: 生产力工具

## 核心功能

### 1. 番茄钟计时
- **工作模式**: 默认 25 分钟，可自定义 15-90 分钟
- **短休息**: 默认 5 分钟，可自定义 3-30 分钟
- **长休息**: 默认 15 分钟，可自定义 10-60 分钟
- **长休息触发**: 完成指定轮次（默认 4 轮）后自动切换到长休息
- **状态管理**: 工作(work) / 休息(rest) / 停止(stopped) 三种状态
- **手动切换**: 暂停时可手动切换工作/休息模式

### 2. 统计与历史
- **今日统计**: 当天完成的番茄钟数量
- **本周统计**: 本周累计完成数量
- **总计统计**: 应用启动以来总完成数量
- **7 天历史图表**: Charts 框架实现的柱状图，显示过去 7 天的完成情况
- **数据持久化**: 使用 UserDefaults 存储历史数据
- **自动重置**: 每日自动重置当天计数、工作轮数，每周自动重置周计数
- **长休息轮数**: `completedRounds` 按天重置，确保只统计当天的工作轮数

### 3. UI/UX 特性
- **菜单栏集成**:
  - 显示倒计时
  - 动态图标：红色番茄（工作中）、绿色番茄（休息中）、灰色番茄（暂停/停止）
  - 左键点击弹出主面板
  - 右键菜单：快速退出
- **主面板** (280×320):
  - 圆形进度条：红色（工作）/ 绿色（休息）
  - 大字体倒计时显示（单行格式 MM:SS）
  - 中央播放/暂停按钮
  - 可点击的统计数字（循环显示今日/本周/总计）
  - 7 天历史图表按钮（弹出 Popover）
  - 重置和退出按钮
  - 设置按钮（右上角齿轮图标）
  - 阶段切换按钮（暂停时可见，左上角）

### 4. 设置功能
- **自动启动控制**:
  - 启动后自动开始工作
  - 工作结束后自动开始休息
  - 休息结束后自动开始下一轮工作
- **时长自定义**: Stepper 控件调整各阶段时长
- **长休息开关**: 可禁用长休息功能
- **高级功能**: 工作期间禁用通知（预留功能）

### 5. 通知系统
- **阶段完成通知**: 工作/休息结束时发送系统通知
- **声音提醒**: 播放系统 Ping 音效（重复 3 次，间隔 0.5 秒）
- **通知内容**:
  - 工作结束: "Work completed. Take a break!"
  - 休息结束: "Rest is over. Time to focus!"

### 6. 状态持久化
- **应用退出/重启恢复**:
  - 保存当前状态（工作/休息/停止）
  - 保存剩余时间
  - 保存时间戳
  - 保存运行状态（是否在计时）
- **智能恢复**:
  - 如果重启时会话已过期，自动进入下一阶段
  - 如果仍有剩余时间，恢复到暂停状态
- **设置同步**: 监听 UserDefaults 变化，暂停时立即应用新的时长设置

## 技术架构

### 文件结构

```
PomodoroTimer/
├── PomodoroTimerApp.swift          # 应用入口，使用 @NSApplicationDelegateAdaptor
├── AppDelegate.swift               # 应用生命周期管理，初始化定时器和菜单栏
├── PomodoroTimer.swift             # 核心业务逻辑类（ObservableObject）
├── ContentView.swift               # 主界面视图 + 7 天统计图表
├── StatusBarController.swift      # 菜单栏控制器，管理 Popover 和图标
├── SettingsView.swift             # 设置界面（SwiftUI）
├── SettingsWindowController.swift # 设置窗口管理器（单例模式）
├── MacSwitchToggle.swift          # 自定义 NSSwitch 封装（未使用）
└── Info.plist                     # LSUIElement=true（无 Dock 图标）
```

### 核心类详解

#### `PomodoroTimer` (核心逻辑)
**位置**: PomodoroTimer.swift

**职责**:
- 定时器生命周期管理
- 状态机（工作/休息/停止）
- 统计数据管理
- 数据持久化
- 通知发送

**关键属性**:
```swift
@AppStorage("workDuration") var workDuration: Int = 25
@Published var timeRemaining: Int = 0
@Published var state: State = .stopped
@Published var dailyWorkSessions: Int = 0
var onUpdateUI: (() -> Void)?  // 回调更新菜单栏
```

**关键方法**:
- `start()`: 启动计时器，创建 1 秒间隔的 Timer
- `pause()`: 暂停计时器，保存状态
- `reset()`: 重置到初始状态
- `toggleCurrentPhase()`: 手动切换工作/休息模式
- `tick()`: 每秒调用，倒计时逻辑，阶段切换
- `saveState()` / `restoreState()`: 状态持久化
- `incrementWorkCounters()`: 更新统计数据
- `lastNDaysHistory(7)`: 生成 7 天历史数据数组

**状态管理**:
```swift
enum State: String, Codable {
    case work, rest, stopped
}
```

**数据存储键**:
- `PomodoroState`: 序列化的状态对象
- `dailyWorkSessions`, `weeklyWorkSessions`, `totalWorkSessions`: 统计计数
- `completedRounds`: 当天完成的工作轮数（用于长休息判断）
- `lastWorkDate`, `lastWeeklyWorkDate`: 日期边界检测
- `dailyHistory`: JSON 编码的 [String: Int] 字典

#### `AppDelegate`
**位置**: AppDelegate.swift

**职责**:
- 初始化 PomodoroTimer 实例
- 创建 StatusBarController
- 请求通知权限
- 设置定时器回调 (`onUpdateUI`)
- 固定主窗口尺寸 (280×320)
- 注册开机启动 (SMAppService)

**关键代码**:
```swift
timer.onUpdateUI = { [weak self] in
    self?.statusBar?.updateTitle(text)
    self?.statusBar?.updateIcon(for: state, isRunning: isRunning)
}
```

#### `StatusBarController`
**位置**: StatusBarController.swift

**职责**:
- 管理菜单栏图标和文字
- 控制 Popover 弹出/关闭
- 处理左键点击（togglePopover）
- 处理右键点击（显示退出菜单）
- 监听外部点击自动关闭 Popover

**图标命名约定**:
- `tomato_red`: 工作中
- `tomato_green`: 休息中
- `tomato_gray`: 暂停/停止

#### `ContentView`
**位置**: ContentView.swift:43-180

**结构**:
- 顶部标题栏：显示当前阶段（Work Time / Rest Time / Long Rest Time）
- 设置按钮（右上角齿轮图标）
- 阶段切换按钮（暂停时左上角）
- 圆形进度条 (160×160)
- 中央区域：
  - 统计按钮（循环显示今日/本周/总计）
  - 倒计时显示（48pt 等宽字体）
  - 播放/暂停按钮（圆形背景）
- 图表按钮（Popover 显示 7 天历史）
- 底部按钮：重置 + 退出

**进度计算**:
```swift
let totalTime = timer.state == .work ? 25 * 60 : 5 * 60
let progress = Double(timer.timeRemaining) / Double(totalTime)
```

**注意**: 这里的 totalTime 是硬编码的，可能与实际设置的时长不一致（潜在 Bug）

#### `StatsView`
**位置**: ContentView.swift:12-41

**功能**: 使用 SwiftUI Charts 显示 7 天柱状图
- X 轴：日期（MM/dd 格式，旋转 -40 度）
- Y 轴：完成的番茄钟数量
- 尺寸: 240×180

#### `SettingsView`
**位置**: SettingsView.swift

**配置项**:
1. 自动启动控制 (3 个 Toggle)
2. 时长设置 (3 个 Stepper + 1 个长休息开关)
3. 高级功能 (1 个 Toggle，未实际使用)

**窗口尺寸**: 420×520

#### `SettingsWindowController`
**位置**: SettingsWindowController.swift

**模式**: 单例模式 (`shared`)
**行为**:
- 如果窗口已存在且可见，激活窗口
- 否则创建新窗口
- 窗口关闭后不释放 (`isReleasedWhenClosed = false`)

## 数据流

### 启动流程
1. `PomodoroTimerApp` 启动
2. `AppDelegate.applicationDidFinishLaunching` 调用
3. 创建 `PomodoroTimer` 实例（自动调用 `init()`）
   - 恢复持久化状态
   - 检查日期边界，重置日/周统计
   - 注册 UserDefaults 监听
4. 创建 `StatusBarController`，传入 `ContentView`
5. 设置 `onUpdateUI` 回调
6. 请求通知权限
7. 启动 1 秒定时器更新菜单栏显示
8. 注册开机启动

### 计时流程
1. 用户点击播放按钮
2. `ContentView` 调用 `timer.start()`
3. `PomodoroTimer.start()`:
   - 设置初始时间（如果是 stopped 状态）
   - 创建 1 秒 Timer
   - 调用 `onUpdateUI`
4. 每秒 `tick()`:
   - `timeRemaining -= 1`
   - 调用 `saveState()`
   - 如果 `timeRemaining == 0`:
     - 如果是工作阶段，调用 `incrementWorkCounters()`
     - 切换到下一阶段（工作→休息 或 休息→工作）
     - 发送通知
     - 调用 `onUpdateUI`

### 设置更新流程
1. 用户在 SettingsView 修改 @AppStorage 值
2. UserDefaults 发送 `didChangeNotification`
3. `PomodoroTimer.init()` 中的 `defaultsCancellable` 接收通知
4. 根据当前状态和是否暂停，更新 `timeRemaining`
5. 调用 `onUpdateUI`

### 统计更新流程
1. 工作阶段结束时调用 `incrementWorkCounters()`
2. 检查日期边界，必要时重置计数
3. 更新 `dailyWorkSessions`, `weeklyWorkSessions`, `totalWorkSessions`
4. 更新 `dailyHistory` 字典
5. 持久化到 UserDefaults

## 关键技术点

### SwiftUI + AppKit 混合
- 主要 UI 使用 SwiftUI
- 菜单栏控制使用 AppKit (NSStatusItem, NSPopover)
- 设置窗口使用 NSWindow + NSHostingController
- MacSwitchToggle 展示了 NSViewRepresentable 用法（但未使用）

### 状态持久化
```swift
private struct SavedState: Codable {
    var state: State
    var timeRemaining: Int
    var timestamp: Date
    var wasRunning: Bool
}
```
- 使用 JSONEncoder/Decoder 序列化
- 重启时根据时间戳计算经过时间
- 如果会话已过期，自动进入下一阶段

### @AppStorage 实时同步
```swift
defaultsCancellable = NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification)
    .sink { [weak self] _ in
        // 根据状态更新 timeRemaining
    }
```

### 日期边界检测与轮数重置
```swift
let today = formattedDate(Date())
if lastDate != today {
    dailyWorkSessions = 0
    completedRounds = 0
    UserDefaults.standard.set(completedRounds, forKey: completedRoundsKey)
}
```
- 使用 `yyyy-MM-dd` 字符串比较
- 周边界使用 `Calendar.current.isDate(_:equalTo:toGranularity: .weekOfYear)`
- **重要**: `completedRounds` 在日期变化时重置为 0 并持久化，确保长休息只根据当天的工作轮数触发
- 每次 `completedRounds` 增加时都会保存到 UserDefaults，应用重启后能正确恢复

### 通知 + 声音
- UserNotifications 框架发送通知
- 同时播放 NSSound（Ping 音效重复 3 次）

### 图表实现
- SwiftUI Charts 框架
- 将 `dailyHistory` 的 [String: Int] 转换为 [Date: Int]
- AxisMarks 自定义 X 轴标签（旋转 -40 度）

## 已知问题和改进空间

### 已修复的问题
1. ✅ **completedRounds 跨天累计问题** (已修复 2026-01-29):
   - 问题：`completedRounds` 未持久化且未按天重置，导致长休息判断可能跨天累计
   - 修复：添加 `completedRoundsKey` 持久化存储，在日期变化时自动重置为 0
   - 位置：PomodoroTimer.swift:47, 56, 68, 152, 172, 227

### 潜在 Bug
1. **ContentView.swift:50** 的进度条计算使用硬编码时长：
   ```swift
   let totalTime = timer.state == .work ? 25 * 60 : 5 * 60
   ```
   应该使用 `timer.workDuration` 等动态值

2. **设置中的功能未实现**:
   - `autoStartWork`, `autoStartRest`, `autoStartNextCycle` 未在代码中使用
   - `disableNotificationsDuringWork` 未实现

3. **长休息判断不一致**:
   - 有些地方使用 `roundsBeforeLongRest > 0 && ...`
   - 设置中有独立的 `enableLongRest` 开关，但未在计时器逻辑中使用

### 改进建议
1. 添加键盘快捷键支持
2. 添加声音/通知开关
3. 支持自定义通知文案
4. 添加深色模式适配
5. 优化图表显示（增加更多时间范围选项）
6. 添加导出统计数据功能
7. 实现设置中预留的自动启动功能

## Git 状态

当前分支: `main`
最近提交:
- `b2df1f8` Update tooltip
- `2c10f47` Add 7-day history chart with readable date format and axis labels
- `f251a09` Add icon for reset button
- `b41fe27` Fix bug: Today: (number) is not clickable sometime
- `85abe80` Change buttons layout + Fix date change bug

工作区状态:
- 修改: ContentView.swift, Info.plist, PomodoroTimer.swift
- 新增: MacSwitchToggle.swift, SettingsView.swift, SettingsWindowController.swift

## 依赖和框架

- **SwiftUI**: 主要 UI 框架
- **AppKit**: 菜单栏和窗口管理
- **UserNotifications**: 系统通知
- **Combine**: UserDefaults 监听
- **Charts**: 统计图表
- **ServiceManagement**: 开机启动

## 开发环境

- **Xcode**: 16F6 (16.4)
- **macOS SDK**: 15.5
- **Swift**: 隐式（Xcode 16 包含 Swift 5.10+）
- **部署目标**: macOS 15.5+

---

**文档生成时间**: 2026-01-29
**文档版本**: 1.1

## 修改历史

### v1.1 (2026-01-29)
- 修复 `completedRounds` 跨天累计问题
- 添加 `completedRoundsKey` 持久化存储
- 更新日期边界检测逻辑说明
- 标记已修复问题

### v1.0 (2026-01-29)
- 初始文档创建
