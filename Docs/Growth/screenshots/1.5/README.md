# App Store Screenshots - v1.5

This folder contains HTML templates for generating App Store screenshots for version 1.5.

## Screenshot Overview

v1.5 introduces **5 screenshots** (increased from 4 in v1.4):

1. **Work Time** - Main timer interface with keyboard shortcuts
2. **Settings** - 📊 NEW: Highlights Statistics Export section
3. **Rest Time** - Break period interface
4. **Chart** - In-app 7-day productivity chart
5. **PDF Export** - 📊 NEW: Professional PDF reports showcase

## What's New in v1.5 Screenshots

### Updated Screenshots:
- **Settings** (`settings-en.html`, `settings-zh.html`)
  - Updated subtitle to highlight Statistics Export
  - Instructions emphasize scrolling to show export buttons

### New Screenshots:
- **PDF Export** (`pdf-export-en.html`, `pdf-export-zh.html`)
  - Showcases PDF reports with visual charts
  - Orange/gold gradient background for distinction
  - Highlights Weekly, Monthly, and All-Time reports

## Screenshot Generation Process

### Step 1: Prepare App
1. Build and run the app
2. Switch system language (English or Chinese)
3. Generate test data if needed (30 days)

### Step 2: Capture Screenshots

For each HTML template:

1. Open the HTML file in a browser
2. Follow the on-screen instructions
3. Take the required app screenshot
4. Save with the specified filename (e.g., `settings-en.png`)
5. Refresh the HTML page to verify
6. Click "Hide Instructions" button
7. Press `Cmd+Shift+4`, then `Space`
8. Click browser window to capture final screenshot

### Step 3: Upload to App Store Connect

Screenshots should be uploaded in this order:
1. Work Time
2. Settings (showing Statistics Export)
3. Rest Time
4. Chart
5. PDF Export (showing report with charts)

## Files Structure

```
1.5/
├── README.md (this file)
├── work-time-en.html
├── work-time-zh.html
├── settings-en.html ⭐ UPDATED
├── settings-zh.html ⭐ UPDATED
├── rest-time-en.html
├── rest-time-zh.html
├── chart-en.html
├── chart-zh.html
├── pdf-export-en.html ⭐ NEW
├── pdf-export-zh.html ⭐ NEW
└── (generated .png files)
```

## Tips

- Ensure Settings window is scrolled to show the "📊 Statistics Export" section
- For PDF Export screenshot, use a sample PDF report with visible charts
- Keep consistent styling across all screenshots
- Use test data showing 30 days of activity for realistic charts
