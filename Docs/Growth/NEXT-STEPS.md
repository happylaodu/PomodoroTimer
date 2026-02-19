# 🎯 接下来要做的事

v1.3 已审核通过，App Store 链接已更新，营销内容已准备完毕。

---

## ✅ 已完成

- ✅ v1.3 审核通过
- ✅ 获取 App Store 链接：https://apps.apple.com/app/pomodoro-timer-lite/id6748662476
- ✅ 更新 README.md（添加 App Store badge 和截图）
- ✅ 准备所有平台的营销内容（见 `06-Ready-To-Publish.md`）
- ✅ 创建 v1.3 git tag
- ✅ 推送更新到 GitHub

---

## 📋 下一步行动（按优先级）

### 0. 将源代码 repo 改为 Public（5分钟）⭐ 新增

**操作步骤**:
1. 打开 https://github.com/happylaodu/PomodoroTimer/settings
2. 滚动到最底部 "Danger Zone"
3. 找到 "Change repository visibility"
4. 点击 "Change visibility" → 选择 "Make public"
5. 按照提示确认（需要输入 `happylaodu/PomodoroTimer` 确认）

**✅ 已检查**:
- ✅ 代码中无敏感信息（API keys、密码等）
- ✅ .gitignore 配置正确
- ✅ entitlements 文件安全

**为什么重要**: 开源是重要的营销卖点，增加用户信任，可能吸引贡献者。

---

### 0.5 更新 pomodoro-support repo 的 README（3分钟）⭐ 新增

**操作步骤**:
1. 打开 https://github.com/happylaodu/pomodoro-support
2. 编辑 README.md（如果已有）或创建新的
3. 复制 `Docs/Growth/pomodoro-support-README.md` 的内容
4. 说明源代码在 PomodoroTimer repo，issues 也在那里

**为什么重要**: App Store 的 support URL 指向这个 repo，需要引导用户到源代码 repo。

---

### 1. 创建 GitHub Release（5分钟）

**操作步骤**:
1. 确保步骤 0 已完成（repo 已改为 public）
2. 打开 https://github.com/happylaodu/PomodoroTimer/releases/new?tag=v1.3
3. 复制 `v1.3-Release-Notes.md` 中的内容
4. 粘贴到 Release 描述中
5. 点击 "Publish release"

**为什么重要**: GitHub Release 是营销的一部分，会通知 watchers 并提升曝光度。

---

### 2. 保存截图到正确位置（5分钟）

你提供的 6 张截图需要保存到项目中（如果想在 README 中显示）：

**目录**: `Docs/Growth/screenshots/`

**建议文件名**（与 README 中引用的匹配）:
- `work-time.png` - 主界面（工作时间）
- `rest-time.png` - 主界面（休息时间）
- `chart.png` - 7天统计图表
- `settings.png` - 设置面板

**或者**: 如果不想在 GitHub README 中显示截图，可以跳过这一步。营销内容中会直接使用截图文件。

---

### 3. 优化 App Store 页面（30分钟）

**位置**: App Store Connect > 你的应用 > App Store

**需要更新的内容**（见 `01-AppStore-Content.md`）:

1. **Description**（描述）
   - 使用优化后的英文/中文描述
   - 突出 "1.5MB" 轻量化卖点
   - 突出 "免费无广告"

2. **Promotional Text**（推广文字）
   - 可随时修改，无需审核
   - 使用 v1.3 的推广文案

3. **Keywords**（关键词）
   - 更新为优化后的关键词列表
   - 英文：pomodoro,timer,focus,productivity...
   - 中文：番茄钟,番茄工作法,计时器...

4. **Marketing URL**
   - 添加：https://github.com/happylaodu/PomodoroTimer

---

### 4. 开始营销推广（本周内）

**参考文档**: `05-Quick-Actions.md` + `06-Ready-To-Publish.md`

#### Phase 1: 准备工作（今天完成）

- [ ] **联系 5-10 位朋友请求试用**
  - 使用 `06-Ready-To-Publish.md` 中的私信模板
  - 目标：获得前 5-10 个评分

#### Phase 2: 社交媒体发布（本周内）

**建议顺序**:

1. **Product Hunt**（周二-周四最佳）
   - 发布时间：美国西岸凌晨 12:01 AM = 渥太华凌晨 3:01 AM
   - 内容：`06-Ready-To-Publish.md` → Product Hunt 部分
   - 重要：发布后前 4-6 小时要积极回复评论

2. **V2EX**（工作日上午 10-11 点北京时间）
   - 板块：/go/create 或 /go/apps
   - 内容：`06-Ready-To-Publish.md` → V2EX 部分

3. **Reddit**（美国东岸上午 8-10 点）
   - 子版块：r/macapps（首选）
   - 内容：`06-Ready-To-Publish.md` → Reddit 部分

4. **知乎**（晚上 8-10 点北京时间）
   - 策略：回答现有问题 + 发原创文章
   - 内容：`06-Ready-To-Publish.md` → 知乎部分

5. **小红书**（晚上 7-9 点北京时间）
   - 配图 + 生活化文案
   - 内容：`06-Ready-To-Publish.md` → 小红书部分

6. **Hacker News**（工作日）
   - Show HN 格式
   - 内容：`06-Ready-To-Publish.md` → Hacker News 部分

---

### 5. 数据追踪（每周一次）

**在 App Store Connect 中查看**:
- 展示次数
- 产品页浏览
- 下载次数
- 转化率
- 评分数量

**记录位置**: `Docs/Growth/Analytics.md`（已有模板）

---

## 📚 相关文档快速索引

| 文档 | 用途 |
|------|------|
| `01-AppStore-Content.md` | App Store 优化内容（描述、关键词等） |
| `02-Version-1.3-Release.md` | v1.3 发布清单和 What's New |
| `03-Marketing-Plan.md` | 完整营销策略和计划 |
| `04-Long-Term-Strategy.md` | 6个月长期增长策略 |
| `05-Quick-Actions.md` | 快速行动清单（按天/周） |
| `06-Ready-To-Publish.md` | **所有平台的准备好的发布内容** ⭐ |
| `v1.3-Release-Notes.md` | GitHub Release 内容 |
| `Analytics.md` | 数据追踪模板 |

---

## 🎯 第一周目标

- [ ] GitHub Release 创建完成
- [ ] App Store 页面优化完成
- [ ] 获得 5+ 朋友试用和评分
- [ ] Product Hunt 发布完成
- [ ] V2EX 发布完成
- [ ] Reddit 至少发布到 1 个 subreddit

---

## ❓ 常见问题

**Q: 我应该同时在所有平台发布吗？**
A: 不建议。按优先级分批发布，这样可以：
- 避免被认为是 spam
- 有时间回复每个平台的评论
- 根据效果调整策略

**Q: Product Hunt 什么时候发布最好？**
A: 周二-周四，美国西岸时间凌晨 12:01 AM（渥太华凌晨 3:01 AM）。前 4-6 小时要积极回复评论。

**Q: 如果没人下载怎么办？**
A: 正常现象。前期重要的是：
1. 积累真实评分（目标 10+）
2. 建立社交证明
3. 优化 App Store 排名
给自己 1-3 个月时间看效果。

---

**创建时间**: 2026-02-01
**状态**: ✅ 准备就绪，开始执行！
