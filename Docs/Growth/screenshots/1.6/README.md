# App Store Screenshots - v1.6

This folder contains templates and guidelines for generating App Store screenshots for version 1.6.

## Screenshot Strategy for v1.6

v1.6 introduces the **Achievement System** - the main selling point that must be showcased.

### 5 Screenshots (in order):

1. **Work Time** - Main timer interface (keep from v1.5)
2. **Achievements** - NEW: Achievement window with dual-tab design ⭐ CORE FEATURE
3. **Settings** - UPDATED: Achievements section at top
4. **Chart** - In-app productivity chart (updated tooltips)
5. **PDF Export** - Professional reports (keep from v1.5)

## What's New in v1.6 Screenshots

### New Screenshots:
- **Achievements** (`achievements-en.html`, `achievements-zh.html`)
  - Must show the dual-tab window (Badges + Statistics)
  - Showcase unlocked and locked achievements
  - Display current streak and statistics
  - This is the MAIN selling point of v1.6

### Updated Screenshots:
- **Settings** (`settings-en.html`, `settings-zh.html`)
  - Achievements section now at top with orange highlight
  - Shows unlock progress (e.g., "Unlocked: 6/9")
  - Blue "View All" button prominent

- **Chart** (optional update)
  - Enhanced tooltip positioning
  - Better hover interaction

### Removed/Replaced:
- Consider if Rest Time is still needed (less important than achievements)

## Screenshot Details

### 1. Work Time (keep from v1.5)
- Main timer interface
- Shows keyboard shortcuts
- Clean, simple design
- **File**: `work-time-en.png`, `work-time-zh.png`

### 2. Achievements (NEW - MOST IMPORTANT)
- **Tab view**: Must show both "Badges" and "Statistics" tabs
- **Badges tab**:
  - Grid layout with 9 achievement cards
  - Color for unlocked, grayscale for locked
  - Show unlock dates on unlocked achievements
  - Display current streak at top
- **Statistics tab**:
  - Visual charts (7 days / 30 days / all time)
  - Period selector
  - Summary statistics at top
- **Screenshot approach**: Capture Badges tab OR split-screen showing both
- **File**: `achievements-en.png`, `achievements-zh.png`

### 3. Settings (UPDATED)
- **Top section**: Achievements with orange "Unlocked: 6/9"
- Blue "View All" button
- Scroll to show achievement section clearly
- Other settings sections visible below
- **File**: `settings-en.png`, `settings-zh.png`

### 4. Chart (optional update)
- In-app 7-day chart
- Enhanced tooltips (if visible in screenshot)
- **File**: `chart-en.png`, `chart-zh.png`

### 5. PDF Export (keep from v1.5)
- Professional PDF reports
- Shows charts in reports
- **File**: `pdf-export-en.png`, `pdf-export-zh.png`

## Screenshot Dimensions

**macOS App Store Requirements**:
- Primary: 1280 x 800 pixels (16:10)
- Alternative: 1440 x 900 pixels
- Format: PNG or JPEG
- Color space: RGB

## Capture Instructions

### Before Starting:
1. Build v1.6 and have some test data:
   - At least 30 days of history
   - 6-8 achievements unlocked
   - Active streak showing
2. Switch system language (English or Chinese)
3. Open app and achievement window

### Achievement Window Screenshot:
1. Click "View All" in Settings to open Achievement window
2. Size window appropriately (500x600 default)
3. **Option A - Badges Tab**:
   - Stay on Badges tab
   - Ensure 6+ achievements are unlocked (colorful)
   - 2-3 remain locked (grayscale)
   - Current streak visible at top
4. **Option B - Statistics Tab** (alternative):
   - Switch to Statistics tab
   - Show chart with data
   - Period selector visible
5. Use Cmd+Shift+4 + Space to capture clean window

### Settings Screenshot:
1. Open Settings window
2. Ensure Achievements section is at top and fully visible
3. Should show "Unlocked: X/9" in orange
4. "View All" button in blue
5. Scroll position shows achievement section + some settings below
6. Capture with Cmd+Shift+4 + Space

### Using HTML Templates:
1. Open HTML template in browser
2. Follow on-screen instructions
3. Capture app screenshot as instructed
4. Save with specified filename
5. Refresh HTML to verify screenshot appears
6. Hide instructions
7. Capture final composed screenshot

## Upload Order to App Store Connect

1. Work Time - Familiar main interface
2. **Achievements** - Lead with the new feature ⭐
3. Settings - Show where to access achievements
4. Chart - Supporting productivity tracking
5. PDF Export - Professional reporting feature

## Files to Create

### Templates Needed:
- [ ] `achievements-en.html` - English achievement showcase
- [ ] `achievements-zh.html` - Chinese achievement showcase
- [ ] `settings-en.html` - Updated with achievements section
- [ ] `settings-zh.html` - Updated with achievements section
- [ ] `work-time-en.html` - Copy from v1.5
- [ ] `work-time-zh.html` - Copy from v1.5
- [ ] `chart-en.html` - Copy from v1.5 (or update)
- [ ] `chart-zh.html` - Copy from v1.5 (or update)
- [ ] `pdf-export-en.html` - Copy from v1.5
- [ ] `pdf-export-zh.html` - Copy from v1.5

## Important Notes

- **Achievement window is the star** - spend most effort here
- Show real data, not empty state
- Ensure achievements are visually appealing (unlocked in color)
- Statistics tab should show actual chart data
- Keep consistent styling with v1.5 templates
- Test both English and Chinese before finalizing

## Marketing Emphasis

The Achievement screenshot should clearly show:
1. Multiple unlocked achievements (proof of gamification)
2. Clear progress tracking (motivational)
3. Professional UI design
4. Both session-based and streak-based achievements
5. Dual-tab interface (more features)

This is what will drive downloads for v1.6!

---

**Status**: Planning phase
**Priority**: High - required for v1.6 App Store submission
**Timeline**: Create before App Store review submission
