# 番茄计时器 - 功能想法

## 准备执行的想法

### Idea-12: [Research] Focus Mode 集成
**提出时间**: 2026-01-31

研究与 macOS Focus Mode 联动的可行性：
- 工作时自动启用勿扰模式
- 之前尝试的方案（私有 API、AppleScript、快捷指令）都不够稳定或实用
- 继续探索其他可能的实现方式
- 可能的新方向：系统扩展、Shortcuts.app 自动化
- 优先级：低（研究性质，可能无法实现）

### Idea-11: [Feature] 音效自定义
**提出时间**: 2026-01-31

添加音效自定义功能：
- 3-5 种提示音选择
- 可关闭音效选项
- 音量调节（可选）
- 参考 TimeMate 的音效设计
- 优先级：中（v1.4 功能）

### Idea-10: [Feature] 全局快捷键
**提出时间**: 2026-01-31

添加全局快捷键支持，允许用户在任何应用下控制番茄钟：
- 启动/暂停: `Cmd+Shift+P`
- 重置: `Cmd+Shift+R`
- 切换模式: `Cmd+Shift+M`
- 参考 Pommie 的快捷键实现
- 优先级：高（v1.4 功能）

### Idea-9: [Feature] 简体中文本地化
**提出时间**: 2026-01-31

将应用完整本地化为简体中文，包括：
- 应用内所有界面文字翻译（SwiftUI 字符串）
- App Store 页面中文版（已有部分内容在 `Docs/Growth/01-AppStore-Content.md`）
- 利用已准备好的中文 What's New 内容
- 预计时间：1-2周
- 优先级：高（v1.4 第一优先功能）

<!-- 新的想法会添加到这里 -->

## 已完成的想法

### Idea-8: [Research] 如何提升月下载量
**提出时间**: 2026-01-31
**完成时间**: 2026-01-31

完成了完整的增长策略分析和执行计划，创建了以下文档（位于 `Docs/Growth/`）：

1. **00-README.md** - 总览和导航
2. **01-AppStore-Content.md** - App Store 优化内容（英文+中文描述、关键词、Promotional Text）
3. **02-Version-1.3-Release.md** - v1.3 发布清单和操作步骤
4. **03-Marketing-Plan.md** - 营销推广详细计划（Product Hunt、V2EX、Reddit、知乎、小红书等）
5. **04-Long-Term-Strategy.md** - 6个月长期增长策略和功能路线图
6. **05-Quick-Actions.md** - 今天/本周立即执行清单
7. **Analytics.md** - 数据追踪模板

**核心发现：**
- 当前 30 天仅 4 次下载，曝光严重不足
- 零评分/评论，缺乏社交证明
- 主要优势：1.5MB 超轻量、完全免费、开源
- 立即行动：发布 v1.3 + App Store 优化 + 营销推广

**预期目标：**
- 1个月：50+ 下载，10+ 评分
- 3个月：200-500 下载/月
- 6个月：进入自然增长轨道

---

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
