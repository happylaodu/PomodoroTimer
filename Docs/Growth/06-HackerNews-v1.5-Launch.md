# 📰 Hacker News v1.5 Launch Plan

Complete strategy for launching Pomodoro Timer Lite v1.5 on Hacker News.

---

## 🎯 Launch Objectives

**Primary Goals:**
- 50-100 App Store downloads (vs 24 GitHub clones last time)
- 100+ upvotes to reach HN frontpage
- 20-30+ constructive comments
- 5-10 App Store ratings from HN users

**Success Metrics:**
- Frontpage position (top 30 posts)
- Time on frontpage (>2 hours ideal)
- App Store conversion rate (clicks → downloads)
- GitHub stars increase

---

## 📅 Optimal Timing

### Best Day & Time

**Recommended Window:**
- **Tuesday-Thursday** (best engagement)
- **8:00-10:00 AM PST** (11:00 AM - 1:00 PM EST)
- **Avoid:** Weekends, Mondays, late Friday

**Your Local Time (Ottawa EST):**
- 11:00 AM - 1:00 PM EST on Tue/Wed/Thu

**Why this timing:**
- HN algorithm favors fresh posts in peak hours
- Maximum US East Coast + West Coast overlap
- Higher chance of reaching frontpage before European evening

---

## 📝 Post Title Options

### Option A: Feature-Focused (Recommended)
```
Show HN: Pomodoro Timer with PDF productivity reports (1.5MB, open source)
```

**Pros:**
- Highlights unique v1.5 feature (PDF reports)
- Mentions lightweight (1.5MB)
- "Show HN" format preferred by community
- Open source attracts developer interest

### Option B: Problem-Solving
```
Show HN: A menu bar Pomodoro timer that exports your productivity data
```

**Pros:**
- Emphasizes data ownership
- Appeals to quantified-self enthusiasts

### Option C: Technical Angle
```
Show HN: I built a 1.5MB Pomodoro app with SwiftUI (now with PDF reports)
```

**Pros:**
- Technical stack mention
- Developer story angle

### **Recommendation:** Use Option A
- Most balanced: feature + size + open source
- Character count: 73 (optimal < 80)

---

## 🔗 Submission Details

### Primary Link
```
https://apps.apple.com/app/pomodoro-timer-lite/id6748662476
```

**Why App Store link:**
- Direct conversion path
- Boosts App Store ranking
- Better than GitHub for users who just want to try it

### Submission Steps

1. **Go to:** https://news.ycombinator.com/submit
2. **Title:** (Use Option A above)
3. **URL:** App Store link
4. **Post immediately after:** Have first comment ready (see below)

---

## 💬 First Comment (Critical!)

Post this as your FIRST comment immediately after submission (within 60 seconds):

```markdown
Hi HN!

I'm the maker of Pomodoro Timer Lite. Just shipped v1.5 with a feature I'm excited about: professional productivity reports.

**What's new in v1.5:**
• Export your Pomodoro sessions to CSV/PDF
• Weekly, monthly, and all-time reports
• Charts showing your productivity trends
• All generated locally - zero cloud, zero tracking

**Why I built this:**

I wanted a Pomodoro timer that:
- Doesn't bloat my Mac (most are 10-30MB, this is 1.5MB)
- Respects my privacy (no analytics, no accounts)
- Lets me own my data (hence the export feature)
- Doesn't cost $10/month

**Tech stack:**
- Pure Swift + SwiftUI (no dependencies)
- Core Graphics for PDF rendering
- Menu bar integration via AppKit
- All data stored in UserDefaults (local only)

The app is free on App Store and fully open source (MIT license).

GitHub: https://github.com/happylaodu/PomodoroTimer

Happy to answer any questions about the implementation or design choices!

**P.S.** If you try it, I'd really appreciate feedback - both positive and critical. Still learning and improving!
```

**Why this format works:**
- Leads with the NEW feature (v1.5)
- Addresses "why another Pomodoro app"
- Technical details for HN audience
- Open source credibility
- Humble tone (not salesy)
- Invites discussion

---

## 🛡️ FAQ Preparation

Prepare these answers BEFORE posting (copy-paste ready):

### Q: "Why Mac only? Any plans for Windows/Linux?"

```
Great question! Focused on macOS first for a few reasons:
1. Smaller scope = faster iteration
2. Native SwiftUI/AppKit lets me keep it at 1.5MB
3. Mac users are my primary audience (productivity-focused)

Would love to do cross-platform, but that would likely require Electron (bloat) or separate codebases. For now, staying lean and Mac-native. If there's enough demand, might explore iOS next.
```

### Q: "How do you achieve 1.5MB? What's the secret?"

```
No secret, just careful choices:
1. Zero dependencies (no CocoaPods, SPM packages)
2. Pure SwiftUI + AppKit (both native to macOS)
3. System sounds instead of bundled audio files
4. Vector icons (SF Symbols) instead of PNG assets
5. No embedded web views or frameworks

Contrast this with Electron apps that bundle an entire Chromium browser...

Source code is on GitHub if you want to see the implementation!
```

### Q: "Why not just use Electron and make it cross-platform?"

```
Fair point! But that would defeat the "lightweight" goal:
- Electron apps typically start at 50-150MB (100x larger)
- Higher memory usage
- Slower startup time

For a simple timer app, shipping a whole browser runtime felt like overkill. Plus, native macOS integration (menu bar, notifications) works better with AppKit.

I'd rather have one excellent platform than mediocre everywhere.
```

### Q: "What about privacy? How do I know you're not tracking?"

```
Valid concern! Here's what I do:
1. The app is 100% open source - you can audit the code
2. Zero network requests (no analytics SDKs, no telemetry)
3. All data stored in local UserDefaults only
4. PDF/CSV exports happen entirely on-device

You can verify this by:
- Building from source yourself
- Using Little Snitch or similar to monitor network traffic
- Reading the ~1500 lines of Swift code on GitHub

Privacy was a core design goal, not an afterthought.
```

### Q: "Is there a way to sync between devices?"

```
Not currently. Deliberate choice for a few reasons:
1. Sync requires cloud backend = privacy/cost concerns
2. Adds complexity (auth, conflict resolution, etc.)
3. Most people use Pomodoro on one device anyway

That said, v1.5 added CSV export specifically so you can:
- Manually back up your data
- Import into your own spreadsheet
- Keep historical records

If there's strong demand for iCloud sync (privacy-preserving), I could explore that in v2.0.
```

### Q: "Why App Store instead of just GitHub releases?"

```
Both, actually! App Store provides:
- Auto-updates
- Sandboxing/security
- Easier discovery for non-technical users
- Notarization (macOS requirement)

But you can always build from source:
https://github.com/happylaodu/PomodoroTimer

App Store version is free (no IAP), so it's just about convenience vs. compile-it-yourself.
```

### Q: "How do you make money from this?"

```
I don't! It's a personal project to:
1. Learn SwiftUI development
2. Scratch my own itch (wanted a better timer)
3. Portfolio piece

Might add optional "tip jar" in the future, but the app will always be free. No ads, no subscriptions, no freemium upsells.

I have a day job - this is just a fun side project that hopefully helps others too.
```

### Q: "What's the tech behind PDF generation?"

```
Good question! Uses Core Graphics (macOS native):

1. Create CGContext for PDF
2. Draw text, charts, tables using CG APIs
3. Calculate layouts manually (no web view)
4. Export to file via NSSavePanel

Entire PDF generator is ~300 lines in StatisticsExporter.swift. Pure Swift, no dependencies.

The tricky part was:
- Chart rendering from scratch (bar charts with labels)
- Pagination for long reports
- Date formatting across locales

If you're interested in the implementation, check out:
https://github.com/happylaodu/PomodoroTimer/blob/main/PomodoroTimer/StatisticsExporter.swift
```

---

## 🎯 Engagement Strategy

### First 2 Hours (Critical Window)

**Immediate Actions (0-30 min):**
1. ✅ Post submission
2. ✅ Post first comment (within 60 seconds)
3. ✅ Monitor for first comments
4. ✅ Reply to ALL comments (even short ones)
5. ✅ Upvote thoughtful questions/feedback

**Active Monitoring (30 min - 2 hours):**
- Refresh every 10-15 minutes
- Reply within 15 minutes to any new comment
- Be friendly, humble, and technical
- Don't argue - acknowledge criticism
- Thank people for trying the app

**Tone Guidelines:**
- ✅ "Great question!"
- ✅ "You're absolutely right about..."
- ✅ "That's a valid criticism..."
- ✅ "Interesting idea! I'll consider..."
- ❌ "Actually, you're wrong..."
- ❌ "This is already explained in the docs..."
- ❌ Defensive or dismissive responses

### Throughout the Day

**2-6 hours after posting:**
- Check every 30-60 minutes
- Reply to new comments
- Share updates if app hits milestones (e.g., "Wow, 50 downloads in 2 hours!")

**6-24 hours:**
- Check 2-3 times
- Reply to stragglers
- Thank everyone at end of day

---

## 📊 Metrics to Track

### HN-Specific Metrics

**During Launch (first 24h):**
- Upvotes (target: 100+ for frontpage)
- Comments (target: 20-30)
- Frontpage position (check https://hnrankings.info/)
- Time on frontpage

**App Store Analytics:**
- Impressions (how many saw the link)
- Product page views (clicks to App Store)
- Downloads (conversions)
- Conversion rate (views → downloads)

**GitHub:**
- Stars increase
- Clones (actual git clones)
- Forks
- Issues/PRs (engagement)

**Create Tracking Sheet:**
```
Date: [Launch Date]
Time Posted: [Time]
HN Link: [URL]

Hour 1:  __ upvotes, __ comments, __ downloads
Hour 2:  __ upvotes, __ comments, __ downloads
Hour 4:  __ upvotes, __ comments, __ downloads
Hour 8:  __ upvotes, __ comments, __ downloads
Day 1:   __ upvotes, __ comments, __ downloads
Week 1:  Total downloads: __
```

---

## 🚀 Pre-Launch Checklist

### 1 Week Before

- [ ] Update README.md with v1.5 features
- [ ] Add v1.5 release notes to GitHub
- [ ] Prepare screenshots for sharing
- [ ] Write blog post (optional, can link in comments)
- [ ] Test App Store link works properly

### 24 Hours Before

- [ ] Verify App Store listing is updated
- [ ] Test PDF export feature thoroughly (users will try it!)
- [ ] Prepare FAQ answers (copy to clipboard)
- [ ] Draft first comment (save in notes app)
- [ ] Set calendar reminder for posting time
- [ ] Clear your schedule for 2-hour active monitoring

### Day Of Launch

**1 Hour Before:**
- [ ] Review title one more time
- [ ] Have first comment ready to copy-paste
- [ ] Test your HN account (can you post?)
- [ ] Close unnecessary tabs (reduce distractions)
- [ ] Grab coffee ☕

**At Launch Time:**
- [ ] Submit post
- [ ] Immediately post first comment
- [ ] Start monitoring
- [ ] Set timer for 10-min check-ins

---

## 🎨 Supporting Materials

### Screenshots to Share

If people ask for screenshots in comments, have these ready:

1. **Menu bar + main window** - Shows the UI
2. **PDF report example** - Highlights v1.5 feature
3. **Settings panel** - Shows customization
4. **7-day chart** - Shows tracking feature

Host on Imgur or similar for quick sharing.

### Video Demo (Optional)

30-second screen recording:
1. Click menu bar icon
2. Start timer
3. Show stats
4. Export PDF
5. Open PDF to show report

Upload to YouTube/Streamable for sharing if requested.

---

## 🔄 Follow-Up Actions

### If Post Does Well (100+ upvotes)

- [ ] Thank the community in a follow-up comment
- [ ] Share on Twitter/X linking to HN thread
- [ ] Monitor App Store rankings
- [ ] Prepare for potential server load (even though it's local-only!)
- [ ] Screenshot the HN thread for portfolio

### If Post Doesn't Reach Frontpage (<50 upvotes)

- [ ] Don't be discouraged - HN is unpredictable
- [ ] Still engage with every commenter
- [ ] Learn from feedback
- [ ] Consider reposting in 2-3 months with major update
- [ ] Focus on other channels (Reddit, Product Hunt)

### Week After Launch

- [ ] Analyze data (see what worked)
- [ ] Reply to any late comments
- [ ] Send thank-you email to people who left App Store reviews
- [ ] Document lessons learned
- [ ] Update long-term strategy based on feedback

---

## 💡 Advanced Tips

### Standing Out on HN

**What HN Users Love:**
- Technical implementation details
- Problem-solving stories
- Open source projects
- Privacy-respecting software
- Lightweight/minimal tools
- "I built this for myself" authenticity

**What to Avoid:**
- Salesy language
- Hype/buzzwords
- Asking for upvotes (against guidelines)
- Multiple submissions (spam)
- Ignoring criticism

### Increasing Frontpage Chances

**HN Algorithm Factors:**
- Early upvotes (first 30 min critical)
- Engagement (comments count)
- Post velocity (upvotes per minute)
- Time of day (8-10 AM PST best)

**Things You Can Do:**
- Post during peak hours ✅
- Engage quickly with comments ✅
- Write compelling first comment ✅
- Have friends organically discover/upvote (don't coordinate voting - that's against rules)

**Things You Cannot Do:**
- Ask for upvotes (vote manipulation = ban)
- Use multiple accounts to upvote
- Have friends coordinate upvoting
- Repost within 6 months

---

## 📎 Related Documents

- [03-Marketing-Plan.md](./03-Marketing-Plan.md) - Overall marketing strategy
- [04-Long-Term-Strategy.md](./04-Long-Term-Strategy.md) - Long-term growth plan
- [01-AppStore-Content.md](./01-AppStore-Content.md) - App Store optimization

---

## 🔗 Useful Links

**HN Guidelines:**
- https://news.ycombinator.com/newsguidelines.html
- https://news.ycombinator.com/showhn.html

**HN Ranking Tracker:**
- https://hnrankings.info/

**App Store Link:**
- https://apps.apple.com/app/pomodoro-timer-lite/id6748662476

**GitHub:**
- https://github.com/happylaodu/PomodoroTimer

---

**Created**: 2026-03-06
**Target Launch**: TBD (Tuesday-Thursday, 11 AM - 1 PM EST)
**Status**: Ready for execution
**Expected ROI**: 50-100 downloads, 100+ upvotes, increased brand awareness
