# v1.6 App Store Screenshots

**Created**: 2026-04-11
**Status**: Preparation

---

## Required Screenshots (5 total)

### Priority Order:
1. **Achievements** ⭐ - Core new feature, dual-tab showcase
2. **Work Time** - Main interface
3. **Settings** - Updated with achievements at top
4. **Chart** - In-app productivity visualization
5. **PDF Export** - Professional reports

---

## Screenshot Specifications

### Technical Requirements:
- **Resolution**: 1280 x 800 pixels
- **Format**: PNG
- **Color Space**: RGB
- **File Size**: < 5MB per image
- **Naming**: Sequential (1-achievements.png, 2-worktime.png, etc.)

### Content Requirements:
- Clean UI, no glitches
- Representative data (30+ days history)
- 6-8 achievements unlocked
- Active streak showing (7+ days ideal)
- Readable text at preview size

---

## Preparation Steps

### 1. Test Data Setup
- [ ] Run app with 30+ days of session history
- [ ] Unlock 6-8 achievements
- [ ] Build active streak (7+ days)
- [ ] Generate statistics data

### 2. Create HTML Templates
- [ ] Copy from v1.3 and modify:
  - [ ] work-time-screenshot.html
  - [ ] chart-screenshot.html
  - [ ] pdf-export-screenshot.html (NEW)
- [ ] Create NEW templates:
  - [ ] achievements-screenshot.html (dual-tab design)
  - [ ] settings-screenshot.html (achievements at top)

### 3. Capture English Screenshots
- [ ] 1-achievements.png - Badges tab with unlocked/locked badges
- [ ] 2-worktime.png - Main timer interface
- [ ] 3-settings.png - Settings with achievements section
- [ ] 4-chart.png - Statistics chart (7/30/all time)
- [ ] 5-pdf-export.png - PDF report preview

### 4. Capture Chinese Screenshots
- [ ] 1-achievements-zh.png
- [ ] 2-worktime-zh.png
- [ ] 3-settings-zh.png
- [ ] 4-chart-zh.png
- [ ] 5-pdf-export-zh.png

### 5. Quality Verification
- [ ] All 1280x800 PNG
- [ ] No UI bugs visible
- [ ] Text readable
- [ ] Consistent styling
- [ ] Dual-tab design clear in achievements screenshot

---

## Screenshot Details

### 1. Achievements Screenshot (PRIORITY)
**Goal**: Showcase v1.6's core feature - achievement system

**Must Show**:
- Dual-tab window (Badges + Statistics tabs)
- Badges tab active by default
- 6-8 unlocked achievements (colorful)
- 1-3 locked achievements (grayscale)
- Current streak display at top
- Clean grid layout (2 columns)
- Professional polish

**Data Needed**:
- Session achievements: First Focus, Getting Started, Dedicated, Centurion
- Streak achievements: Week Warrior (7 days), maybe Monthly Master (30 days)
- Locked: Legend, Immortal, Hundred Days

**Tips**:
- Take screenshot when badges tab is active
- Ensure good mix of unlocked/locked for visual appeal
- Current streak should be impressive (7-14 days ideal)

### 2. Work Time Screenshot
**Goal**: Show main timer interface during work session

**Must Show**:
- Timer counting down
- Work mode indicator
- Session counter
- Clean menu bar integration
- Animation state

**Reuse from v1.3**: Yes, just verify UI still matches

### 3. Settings Screenshot
**Goal**: Show customization options with achievements at top

**Must Show**:
- Achievements section at TOP
- Unlock progress (e.g., "Unlocked: 6/9")
- "View All" button prominent
- Other settings sections below
- Clean layout

**Changes from v1.3**:
- Achievements moved to top position
- Orange highlight on unlock count
- Blue "View All" button
- Window height increased

### 4. Chart Screenshot
**Goal**: Show productivity visualization

**Must Show**:
- Bar chart with 30+ days of data
- Time range options (7 days / 30 days / all time)
- Data trends visible
- Clean, readable labels

**Reuse from v1.3**: Yes, can reuse chart template

### 5. PDF Export Screenshot
**Goal**: Show professional report generation

**Must Show**:
- PDF preview of report
- Charts included in PDF
- Summary statistics
- Daily breakdown table
- Professional formatting

**New for v1.6**: Highlight PDF export feature prominently

---

## File Naming Convention

### English:
```
1-achievements.png
2-worktime.png
3-settings.png
4-chart.png
5-pdf-export.png
```

### Chinese:
```
1-achievements-zh.png
2-worktime-zh.png
3-settings-zh.png
4-chart-zh.png
5-pdf-export-zh.png
```

### Templates - English (5):
```
achievements-screenshot.html
work-time-screenshot.html
settings-screenshot.html
chart-screenshot.html
pdf-export-screenshot.html
```

### Templates - Chinese (5):
```
achievements-screenshot-zh.html
work-time-screenshot-zh.html
settings-screenshot-zh.html
chart-screenshot-zh.html
pdf-export-screenshot-zh.html
```

**Total: 10 HTML templates (5 EN + 5 ZH)**

---

## Timeline

1. **Today**: Create templates, prepare test data
2. **Tomorrow**: Capture all screenshots (EN + ZH)
3. **Day 3**: Quality check, upload to App Store Connect

---

## References

- App Store Screenshot Guidelines: https://developer.apple.com/app-store/product-page/
- v1.3 Screenshots: `../1.3/`
- Release Checklist: `../../v1.6-Release-Checklist.md`

---

**Last Updated**: 2026-04-11
