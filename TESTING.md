# Testing Guide

## 重要说明

⚠️ **应用使用App Sandbox**，UserDefaults存储在：
```
~/Library/Containers/com.brightjune.PomodoroTimer/Data/Library/Preferences/com.brightjune.PomodoroTimer.plist
```

**不是** `~/Library/Preferences/`

## UserDefaults Backup & Restore（推荐）

### 备份当前数据

```bash
swift backup_sandbox_defaults.swift
```

这会将sandboxed plist备份到 `~/.pomodoro_sandbox_backup.plist`

### 恢复备份数据

```bash
swift restore_sandbox_defaults.swift
```

从备份文件恢复sandboxed数据

### 测试工作流程

```bash
# 1. 测试前备份
swift backup_sandbox_defaults.swift

# 2. 运行测试
xcodebuild test -scheme PomodoroTimer -destination 'platform=macOS'

# 3. 测试后恢复
swift restore_sandbox_defaults.swift
```

## 查看当前数据

```bash
# 查看sandbox plist
plutil -p ~/Library/Containers/com.brightjune.PomodoroTimer/Data/Library/Preferences/com.brightjune.PomodoroTimer.plist

# 或者运行诊断
./diagnose.sh
```

## 备份文件位置

- **Sandbox备份**：`~/.pomodoro_sandbox_backup.plist` （✅ 推荐使用）
- 旧备份：`~/.pomodoro_defaults_backup.json` （不适用于sandbox）

## 数据字段

- `dailyWorkSessions` - 今天的番茄钟数
- `weeklyWorkSessions` - 本周（已废弃，现从dailyHistory计算）
- `totalWorkSessions` - 历史总数
- `dailyHistory` - 每日历史（JSON encoded Data）
- `completedRounds` - 今天完成的轮数
- `lastWorkDate` - 上次工作日期

## 注意事项

⚠️ **重要**：
1. 运行单元测试可能清除数据，务必先备份
2. 应用使用sandbox，数据在Containers目录
3. 命令行的`UserDefaults.standard`和应用内的domain不同
