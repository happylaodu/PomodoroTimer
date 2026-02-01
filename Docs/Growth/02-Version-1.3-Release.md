# 🚀 Version 1.3 发布清单

完整的版本发布流程和所需内容。

---

## ✅ 发布前检查清单

### 代码准备
- [x] Info.plist 版本号更新 (1.2 → 1.3)
- [x] Build 号更新 (6 → 7)
- [ ] 代码编译无错误
- [ ] 在本地测试所有新功能
- [ ] 检查 Settings 面板功能正常
- [ ] 验证暗色模式显示正常

### 文档准备
- [ ] 更新 README.md（如需要）
- [ ] 准备 What's New 文案
- [ ] 准备截图（可选：Settings 界面）

---

## 📝 What's New in Version 1.3

### 英文版（English U.S.）

```
New in Version 1.3:

⚙️ SETTINGS PANEL
• Customize work duration (15-90 min)
• Customize short rest (3-30 min) and long rest (10-60 min)
• Auto-start options for seamless workflow
• Configure rounds before long rest

📊 ENHANCED TRACKING
• Improved session counters
• Better daily/weekly statistics

🎨 UI IMPROVEMENTS
• Refined interface design
• Better Settings window management

🐛 BUG FIXES
• Fixed pause button resetting timer to initial value
• Fixed toggle graying out issue in Settings window
• Improved state restoration when app restarts

🛠️ DEVELOPER TOOLS
• Added VS Code build configuration
• Improved project structure

Stay focused with more control over your Pomodoro sessions!
```

### 简体中文版（Simplified Chinese）

```
版本 1.3 新功能：

⚙️ 设置面板
• 自定义工作时长（15-90 分钟）
• 自定义短休息（3-30 分钟）和长休息（10-60 分钟）
• 自动开始选项，无缝工作流
• 配置长休息前的工作轮数

📊 增强的统计功能
• 改进的时段计数器
• 更好的每日/每周统计

🎨 界面优化
• 精致的界面设计
• 更好的设置窗口管理

🐛 Bug 修复
• 修复暂停按钮会重置计时器的问题
• 修复设置窗口开关变灰的问题
• 改进应用重启时的状态恢复

🛠️ 开发者工具
• 添加 VS Code 编译配置
• 改进项目结构

专注工作，掌控你的番茄时段！
```

---

## 🔧 Xcode 操作步骤

### 1. 打开项目

```bash
cd /Users/stevendu/Xcode_projects/PomodoroTimer
open PomodoroTimer.xcodeproj
```

### 2. 验证版本号

1. 在 Xcode 中选择项目根节点
2. 选择 Target: PomodoroTimer
3. 进入 General > Identity
4. 确认：
   - **Version**: 1.3
   - **Build**: 7

### 3. 清理构建

```
Product > Clean Build Folder (Cmd+Shift+K)
```

### 4. Archive 构建

1. 选择设备：**Any Mac (Apple Silicon, Intel)**
2. 菜单：**Product > Archive**
3. 等待构建完成（约 2-5 分钟）

### 5. 上传到 App Store Connect

1. Archive 完成后自动打开 **Organizer**
2. 选择刚才的 Archive（最上方）
3. 点击 **Distribute App**
4. 选择 **App Store Connect**
5. 选择 **Upload**
6. 选择自动签名或手动签名
7. 点击 **Upload**
8. 等待上传完成

**预计时间**: 10-30 分钟

---

## 📱 App Store Connect 操作步骤

### 1. 登录

访问：https://appstoreconnect.apple.com

### 2. 创建新版本

1. 进入 **My Apps**
2. 选择 **Pomodoro Timer Lite**
3. 点击左侧 **macOS App**
4. 点击 **+ Version or Platform**
5. 选择 **macOS**
6. 输入版本号：**1.3**
7. 点击 **Create**

### 3. 选择构建

1. 在 **Build** 部分点击 **Select a build**
2. 等待构建处理完成（可能需要 10-60 分钟）
3. 选择 **1.3 (7)**

### 4. 填写 What's New

复制上面的 **What's New** 内容：
- 英文版 → English (U.S.)
- 中文版 → Simplified Chinese（如已添加本地化）

### 5. 更新其他内容（可选）

同时更新以下内容（参考 `01-AppStore-Content.md`）：
- [ ] Description（描述）
- [ ] Promotional Text（推广文字）
- [ ] Keywords（关键词）
- [ ] Marketing URL

### 6. 提交审核

1. 滚动到页面底部
2. 点击 **Add for Review**
3. 回答出口合规问题（通常选 No）
4. 点击 **Submit to App Review**

**提示**: 确保勾选 **Automatically release this version**

---

## ⏱ 预计时间线

| 步骤 | 时间 | 说明 |
|------|------|------|
| Xcode Archive | 5-10 分钟 | 编译打包 |
| 上传到 ASC | 10-30 分钟 | 取决于网络速度 |
| 构建处理 | 30-60 分钟 | Apple 服务器处理 |
| 填写信息 | 15-30 分钟 | 文案准备好的话很快 |
| 审核等待 | 1-3 天 | 平均 24-48 小时 |
| **总计** | **1-4 天** | 从提交到上线 |

---

## 🎯 审核通过后立即执行

### Day 1: 审核通过当天

1. **验证上线**
   - 检查 App Store 是否显示 1.3 版本
   - 确认 What's New 显示正常
   - 测试下载安装

2. **更新 GitHub**
   - 创建 Git tag: `v1.3`
   - 更新 README.md 提及新功能
   - 发布 GitHub Release

3. **开始营销推广**
   - 发布 Product Hunt（参考 `03-Marketing-Plan.md`）
   - 发布 V2EX 帖子
   - 分享到社交媒体

### Day 2-7: 推广期

1. **持续营销**
   - 知乎回答问题
   - 小红书发教程
   - Reddit 发帖

2. **收集评分**
   - 联系朋友/同事试用
   - 请求真实评价

3. **监控数据**
   - 每天查看 App Store Connect Analytics
   - 记录下载量、展示次数

---

## 📊 成功指标

**第一周目标：**
- [ ] 10+ 下载
- [ ] 3-5 个评分
- [ ] Product Hunt 发布完成

**第一个月目标：**
- [ ] 50+ 下载
- [ ] 10+ 评分（4.5+ 星）
- [ ] 展示次数提升 3-5 倍

---

## 🐛 常见问题

### Q: Archive 时提示代码签名错误？
**A**: 检查 Signing & Capabilities，确保选择了正确的 Team 和 Provisioning Profile。

### Q: 构建上传后在 ASC 找不到？
**A**: 等待 30-60 分钟，构建需要处理时间。检查邮箱是否有错误通知。

### Q: 审核被拒怎么办？
**A**:
1. 阅读拒绝原因
2. 修复问题
3. 在 Resolution Center 回复
4. 重新提交（无需新 Build，除非代码修改）

### Q: 可以先提交审核，稍后再改描述吗？
**A**: 可以。Description、Keywords、Promotional Text 可以随时修改，无需重新审核。但 What's New 提交后无法修改。

---

## 📎 相关文档

- [01-AppStore-Content.md](./01-AppStore-Content.md) - App Store 内容优化
- [03-Marketing-Plan.md](./03-Marketing-Plan.md) - 营销推广计划
- [05-Quick-Actions.md](./05-Quick-Actions.md) - 快速行动清单

---

**创建时间**: 2026-01-31
**版本**: 1.3
**状态**: ✅ Info.plist 已更新，待构建上传
