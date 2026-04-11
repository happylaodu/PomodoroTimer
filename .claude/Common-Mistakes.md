# Common Mistakes Reference

This file documents critical mistakes and lessons learned to prevent repeated errors.

---

## Critical Mistakes

### App Store Connect Limitations

**Issue**: App Store Connect does not support emoji and special characters in metadata

**What happened**:
- Prepared v1.6 release notes with emoji symbols (🏆, 🎉, ✨, 🎨, 🌍)
- App Store Connect rejected the submission due to unsupported characters
- Had to manually remove all emojis before submission
- Also affected App Description and Promotional Text

**Solution**:
- Use text markers instead: `【标题】` for Chinese, `[Section Title]` for English
- Never use emoji in ANY App Store metadata:
  - Release notes (What's New)
  - App Description
  - Promotional Text
  - Subtitle
- Emoji are fine for GitHub releases, documentation, and in-app content

**Prevention**:
- When preparing App Store content, use only:
  - Plain text
  - Basic punctuation
  - Numbers and letters
  - Text-based section markers like brackets

**Files to check before App Store submission**:
- Release checklists (e.g., `Docs/Growth/v1.6-Release-Checklist.md`)
- App Store content file (`Docs/Growth/01-AppStore-Content.md`)
- Release notes (both Chinese and English versions)
- App Description
- Promotional Text

**Example of correct format**:
```
Version 1.6 - Achievement System

[New Features]
• Achievement badges
• Progress tracking

[Improvements]
• Better UI design
• Bilingual support
```

---

## Common Bugs

### UserDefaults Data Operations

**Issue**: Directly clearing UserDefaults can cause data loss

**What happened**:
- Need to review project_context.md "问题0" for full details
- UserDefaults operations need careful handling

**Solution**:
- Always backup data before modifications
- Use migration versioning for data structure changes
- Test data operations thoroughly

---

## Best Practices

### Release Process

1. **Version Number Updates**
   - Update `MARKETING_VERSION` in project.pbxproj
   - Update `CURRENT_PROJECT_VERSION` (build number)
   - Commit version changes separately

2. **Release Notes Preparation**
   - GitHub: Can use emoji and rich formatting
   - App Store: Plain text only, no emoji
   - Prepare both English and Chinese versions

3. **Testing Before Release**
   - Test all new features
   - Regression test existing functionality
   - Test in both English and Chinese environments

---

## Quick Reference Checklist

### Before Every App Store Submission

- [ ] Remove all emoji from App Store release notes
- [ ] Check for special characters
- [ ] Verify both language versions
- [ ] Test on minimum supported macOS version
- [ ] Review migration logic if data structure changed
- [ ] Backup important data before testing migrations

---

**Last Updated**: 2026-04-11
**Related**: See `.claude/Ideas.md` (Idea-23) for context
