# 番茄计时器 - 功能想法

## 准备执行的想法

### Idea-8: [Research] 如何提升月下载量
**提出时间**: 2026-01-31

看一下如何提升月下载量，分析当前产品状况并提出改进建议。

---

<!-- 新的想法会添加到这里 -->

## 已完成的想法

### Idea-7: [Config] 在 VS Code 中编译、运行 app
**提出时间**: 2026-01-31
**完成时间**: 2026-01-31

已配置 VS Code 支持编译和运行 PomodoroTimer 应用。创建了以下配置文件：
- `.vscode/tasks.json`: 配置了编译任务（使用 xcodebuild）和清理任务
- `.vscode/launch.json`: 配置了调试运行和普通运行两种启动方式
- `.vscode/settings.json`: 配置了 Swift 和 LLDB 路径

使用方式：
- 编译：Cmd+Shift+B 或运行 "Build PomodoroTimer" 任务
- 运行：F5 启动调试，或选择 "Run PomodoroTimer (No Debug)" 配置

建议安装 VS Code 扩展：
- Swift Language（sswg.swift-lang）
- CodeLLDB（vadimcn.vscode-lldb）

---

### Idea-6: [Config] 增加 GitHub MCP server
**提出时间**: 2026-01-31
**完成时间**: 2026-01-31

GitHub MCP server 应配置在项目根目录的 `.mcp.json` 文件中（而非 `.claude/settings.local.json`）。用户选择自行配置。

---

### Idea-2: [Testing] 验证 skills 是否可以作为 command 使用
**提出时间**: 2026-01-29
**完成时间**: 2026-01-31

验证完成：skills 和 commands 是同一个概念。`.claude/commands/` 目录下的 `.md` 文件既是 command 也是 skill，可以通过 `/command-name` 或 Skill tool 调用。项目本地和全局的 commands 都能正常工作。

---

### Idea-4: [Bug Fix] Fix Settings Window Toggle Graying Out Issue
**提出时间**: 2026-01-30
**完成时间**: 2026-01-31

解决 Settings 窗口里的 toggle 偶尔全部变灰的问题。修改 SettingsWindowController 每次都创建新窗口实例，而不是重用旧窗口，确保 SwiftUI 视图状态正确刷新。

---

### Idea-3: [Feature] new-idea 支持 global 参数
**提出时间**: 2026-01-29
**完成时间**: 2026-01-29

new-idea 默认不带参数，但是用户可以选择带 global 参数。如果带 global，就意味新加的 idea 是要放到 `~/.claude` 的 Ideas.md 文件中，而不是当前 project 的 Ideas.md 文件中。

---

<!-- 已完成的想法会移到这里 -->

## 已拒绝的想法

### Idea-5: [Testing] 验证工作时禁用通知功能是否有效
**提出时间**: 2026-01-31
**拒绝原因**: macOS 不提供公开 API 或可靠的编程方式控制勿扰模式。尝试的方案包括：(1) 快捷指令 - 需要用户手动配置；(2) AppleScript 模拟键盘 - 默认没有勿扰模式快捷键且会与其他应用冲突；(3) 私有 API - 违反 App Store 政策。所有方案都不够稳定或实用。

---

### Idea-1: [UX] 在 Xcode 中通过符号链接访问 .claude 目录
**提出时间**: 2026-01-29
**拒绝原因**: Xcode 不支持将符号链接作为可展开的目录显示，会将其显示为文件。尝试的其他方法（Add Files with folder references）在实际操作中也无法找到对应选项。

---

<!-- 已决定不实现的想法会移到这里，包含拒绝原因 -->

---

**创建时间**: 2026-01-29
