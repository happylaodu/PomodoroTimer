# Focus Mode Integration Research

**Research Date**: 2026-02-24
**Status**: Completed
**Conclusion**: Not feasible for App Store distribution without user-initiated setup

---

## Executive Summary

After comprehensive research into macOS Focus Mode integration options, **there is no official Apple API that allows third-party apps to programmatically enable or disable Focus Mode**. The available APIs only permit apps to:
1. **Read** Focus status (with special entitlements)
2. **React** to Focus changes within their own app
3. **Filter** app-specific content during Focus

All workarounds require either:
- User manual setup (Shortcuts automation)
- Accessing private system files (violates sandboxing/App Store policies)
- Using private APIs (violates App Store policies)

**Recommendation**: Focus Mode integration is **not feasible** for App Store distribution at this time. Consider alternative approaches (see Alternatives section).

---

## Research Findings

### 1. Official Apple APIs

#### 1.1 Focus Status API (`INFocusStatusCenter`)

**What it does**: Allows apps to READ the current Focus status

**Requirements**:
- Communication Notifications capability in Xcode
- User authorization via `requestAuthorization()`
- Limited to communication-type apps

**Example usage**:
```swift
import Intents

// Request authorization
INFocusStatusCenter.default.requestAuthorization { status in
    if status == .authorized {
        // Check if Focus is enabled
        let isFocused = INFocusStatusCenter.default.focusStatus.isFocused
    }
}
```

**Limitations**:
- ❌ Cannot ENABLE Focus Mode
- ❌ Cannot DISABLE Focus Mode
- ✅ Can only READ current status
- ⚠️ Requires Communication Notifications entitlement (intended for messaging/calling apps)

**Verification Result** (2026-02-24):
⚠️ **CONFIRMED: Requires Communication Notifications Entitlement**

Test procedure:
1. Added `NSFocusStatusUsageDescription` to Info.plist
2. Called `INFocusStatusCenter.default.requestAuthorization()`
3. Authorization granted successfully (status = 3 = authorized)
4. Manually enabled Do Not Disturb mode
5. Attempted to read `INFocusStatusCenter.default.focusStatus.isFocused`

Test results:
```
=== Focus Status API Test ===
Authorization Status: 3 (authorized)
✅ Authorization granted

Error: DNDErrorDomain Code=1004
"App is missing Communication Notifications entitlement."

Is Focus enabled: false
ℹ️ Focus is OFF - Try enabling Focus Mode and relaunch
```

**Critical finding**: Even with user authorization, reading Focus status requires the **Communication Notifications entitlement** (`com.apple.developer.usernotifications.communication`), which Apple only grants to:
- 📞 Communication apps (VoIP, calling apps)
- 💬 Messaging apps
- 📧 Email clients

**App Store risk**: **HIGH** - Requesting this entitlement for a productivity/timer app will likely result in App Review rejection as the app type doesn't match the entitlement's intended use case.

**Verdict**: **Not viable** for productivity apps without communication features.

**Source**: [Apple Developer Forums - Focus Status API](https://developer.apple.com/forums/thread/682143)

#### 1.2 Focus Filters API

**What it does**: Allows apps to customize behavior when user-activated Focus changes

**Use case**: Apps like Mail or Messages can filter content based on active Focus

**Example**: Calendar app hiding personal events during "Work" Focus

**Limitations**:
- ❌ Cannot control Focus activation
- ✅ Can only react to Focus changes
- ✅ Can filter app-specific content

**Source**: [Apple Developer Documentation - Focus Filters](https://developer.apple.com/documentation/AppIntents/defining-your-app-s-focus-filter)

---

### 2. Workarounds and Third-Party Solutions

#### 2.1 Shortcuts Automation

**Method**: Create a Shortcut that controls Focus Mode, then execute it programmatically

**Implementation**:
```bash
# Terminal command to run a shortcut
shortcuts run "Enable Do Not Disturb"
```

**How it works**:
1. User manually creates a Shortcut in Shortcuts.app that enables Focus
2. App executes the shortcut using `shortcuts` CLI tool or URL scheme
3. Shortcut triggers Focus Mode on behalf of the user

**Examples**:
- [macos-focus-mode](https://github.com/arodik/macos-focus-mode) - NodeJS library
- [Terminal Focus Mode](https://heyfocus.com/blog/how-to-turn-on-mac-focus-mode-from-the-terminal/)

**Real-world use case** ([Source](https://talk.automators.fm/t/set-focus-mode-on-macos/13170/3)):
```
Workflow:
1. Create a shortcut to set focus mode (e.g., "Set Theater Focus Mode")
2. HomeKit automation to "Run script over SSH" when motion is detected
3. Script command: shortcuts run "Set Theater Focus Mode"
4. Focus mode syncs across devices
5. iPhone Focus automation triggers Apple Watch theater mode
```

This demonstrates that Shortcuts-based Focus control **does work** for automation scenarios, but requires:
- Manual Shortcut creation
- SSH access (for remote triggers) or `shortcuts` CLI tool
- Cross-device sync via iCloud

**Limitations**:
- ❌ Requires user to manually create and install shortcuts
- ❌ Not a seamless user experience
- ❌ May require Terminal permissions
- ❌ Breaks if user deletes the shortcut
- ⚠️ App Store may reject apps relying on external shortcuts

**Verification Result** (2026-02-24):
✅ **CONFIRMED WORKING** - Tested and verified:
- Created shortcut "Enable Do Not Disturb" with Set Focus → On
- Created shortcut "Disable Do Not Disturb" with Set Focus → Off
- Both shortcuts execute successfully via `shortcuts run "<name>"`
- Focus Mode activates/deactivates as expected

**Verdict**: **Technically viable** but requires user setup. Suitable for optional "power user" feature, not for seamless out-of-box experience.

#### 2.2 Reading Focus Mode Status from System Files

**Method**: Access macOS DoNotDisturb database files directly

**Files**:
- `~/Library/DoNotDisturb/DB/ModeConfigurations.json` - Available Focus modes
- `~/Library/DoNotDisturb/DB/Assertions.json` - Current active mode

**Example**: [JXA Focus Mode Reader](https://gist.github.com/drewkerr/0f2b61ce34e2b9e3ce0ec6a92ab05c18)

**Limitations**:
- ❌ Can only READ status, not CONTROL Focus
- ❌ Violates macOS sandboxing (App Store rejection)
- ❌ Undocumented behavior, may break in future macOS versions
- ❌ Requires file system permissions

**Verdict**: **Not viable** for App Store apps

#### 2.3 AppleScript / UI Automation

**Method**: Use AppleScript to simulate keyboard shortcuts or menu clicks

**Previous attempts** (from Idea-5 rejection):
- No default keyboard shortcut for Do Not Disturb
- Simulating Control Center clicks is unreliable
- Conflicts with other apps

**Limitations**:
- ❌ Requires Accessibility permissions
- ❌ Fragile, breaks with macOS UI changes
- ❌ Poor user experience
- ❌ App Store may reject

**Verdict**: **Not reliable**

#### 2.4 Private APIs

**Method**: Use undocumented system frameworks

**Limitations**:
- ❌ Violates App Store Review Guidelines (2.5.1)
- ❌ May break in future macOS versions
- ❌ Risk of app rejection

**Verdict**: **Not acceptable** for App Store distribution

---

### 3. System Extensions

**Investigated**: Whether System Extensions could provide Focus control

**Findings**:
- System Extensions are for low-level functionality (network filtering, endpoint security)
- Do NOT provide access to Focus Mode controls
- Designed for different use cases entirely

**Sources**:
- [Microsoft Intune - macOS System Extensions](https://learn.microsoft.com/en-us/intune/intune-service/configuration/kernel-extensions-overview-macos)

**Verdict**: **Not applicable**

---

### 4. App Store Policy Considerations

**Relevant Guidelines**:
- **2.5.1**: Apps may not use protected APIs without authorization
- **5.1.1**: Apps may not monetize built-in OS capabilities

**Analysis**:
- No official API exists for controlling Focus Mode
- All workarounds involve either:
  - Accessing private files (policy violation)
  - Using private APIs (policy violation)
  - Requiring extensive user setup (poor UX)

**Verdict**: No App Store-compliant solution exists

---

## Alternatives and Recommendations

Since direct Focus Mode integration is not feasible, consider these alternatives:

### Alternative 1: User Education (Recommended)

**Approach**: Guide users to set up native macOS Focus automation

**Implementation**:
1. Add a Settings section: "🔔 Notifications"
2. Provide a "How to set up Focus Mode" guide
3. Link to System Settings > Focus

**Benefits**:
- ✅ Uses official macOS features
- ✅ No App Store policy violations
- ✅ User has full control
- ✅ No maintenance burden

**Example UI**:
```
⚙️ Notifications

□ Mute notifications during work sessions
  ⓘ This app cannot automatically control Focus Mode due to macOS
     limitations. To mute notifications during work sessions:

     1. Open System Settings > Focus
     2. Create a new Focus or customize "Do Not Disturb"
     3. Set up automation to activate during work hours

     [Open Focus Settings]
```

### Alternative 2: In-App Notification Muting

**Approach**: Control only PomodoroTimer's own notifications

**Implementation**:
```swift
// Disable sound during work sessions
func startWorkSession() {
    UserDefaults.standard.set(false, forKey: "soundEnabled")
    // Optionally suppress notifications
}
```

**Benefits**:
- ✅ Fully controlled by app
- ✅ No permissions required
- ✅ Simple implementation

**Limitations**:
- ⚠️ Only affects PomodoroTimer notifications
- ⚠️ Doesn't prevent other apps' notifications

### Alternative 3: Shortcuts Integration (Optional Power User Feature)

**Approach**: Provide optional integration for advanced users

**Implementation**:
1. Document how to create a custom Shortcut
2. Provide URL scheme to trigger from external shortcuts
3. Don't require it for core functionality

**Benefits**:
- ✅ Powerful for users who want it
- ✅ Optional, not required
- ✅ Doesn't impact App Store compliance

**Drawbacks**:
- ⚠️ Complex setup
- ⚠️ Only for power users

---

## Technical Implementation Reference

### ❌ Reading Focus Status (NOT RECOMMENDED)

**Status**: Tested but not viable due to entitlement requirements.

For reference only (tested 2026-02-24, requires Communication Notifications entitlement):

```swift
import Intents

class FocusStatusManager {
    static let shared = FocusStatusManager()

    func requestAuthorization() {
        INFocusStatusCenter.default.requestAuthorization { status in
            switch status {
            case .authorized:
                print("Focus status authorized")
            case .denied:
                print("Focus status denied")
            case .restricted:
                print("Focus status restricted")
            case .notDetermined:
                print("Focus status not determined")
            @unknown default:
                break
            }
        }
    }

    func isFocusEnabled() -> Bool {
        guard INFocusStatusCenter.default.authorizationStatus == .authorized else {
            return false
        }
        return INFocusStatusCenter.default.focusStatus.isFocused
    }
}
```

**Requirements**:
1. Add Communication Notifications capability in Xcode
2. Add to Info.plist:
```xml
<key>NSFocusStatusUsageDescription</key>
<string>PomodoroTimer uses Focus status to adjust notifications during work sessions.</string>
```

### Reacting to Focus Changes

```swift
extension IntentHandler: INShareFocusStatusIntentHandling {
    func handle(intent: INShareFocusStatusIntent,
                completion: @escaping (INShareFocusStatusIntentResponse) -> Void) {

        if intent.focusStatus?.isFocused == true {
            // User enabled Focus - adjust app behavior
            disableAppSounds()
        } else {
            // User disabled Focus - restore app behavior
            enableAppSounds()
        }

        let response = INShareFocusStatusIntentResponse(code: .success, userActivity: nil)
        completion(response)
    }
}
```

---

## Conclusion

**Final Recommendation**: **Do not implement Focus Mode integration** for the following reasons:

### Tested and Verified (2026-02-24)

| Approach | Technical Result | App Store Viability | Verdict |
|----------|-----------------|---------------------|---------|
| **Shortcuts Automation** | ✅ Working | ⚠️ Requires manual setup | Optional power user feature |
| **INFocusStatusCenter** | ⚠️ Needs special entitlement | ❌ High rejection risk | Not viable |
| **System Files** | Not tested | ❌ Violates sandboxing | Not viable |
| **Private APIs** | Not tested | ❌ Violates policies | Not viable |

### Key Findings

1. ❌ **No official API to control Focus Mode programmatically**
   - Confirmed through testing and documentation review

2. ✅ **Shortcuts approach works technically**
   - Verified: `shortcuts run "Enable Do Not Disturb"` successfully activates Focus
   - Limitation: Requires users to manually create shortcuts first
   - UX impact: Not seamless for average users

3. ⚠️ **Reading Focus status requires special entitlement**
   - Tested: `INFocusStatusCenter` requires Communication Notifications entitlement
   - Error: `DNDErrorDomain Code=1004 "App is missing Communication Notifications entitlement"`
   - App Store risk: HIGH - entitlement restricted to communication apps only

4. ❌ **Poor user experience for mainstream users**
   - Manual setup steps break the "it just works" expectation
   - Maintenance burden if shortcuts are deleted or renamed

5. ✅ **Native macOS Focus automation is sufficient**
   - Users can set up Focus automation in System Settings
   - More reliable than app-based workarounds

### Recommended Implementation

**Instead, implement**:
- **Alternative 1** (User Education) - Guide users to native Focus settings
- **Alternative 2** (In-App Muting) - Control only PomodoroTimer's notifications

This provides a better user experience while remaining App Store compliant.

---

## References

1. [Apple Developer - Focus API](https://developer.apple.com/documentation/appintents/focus)
2. [Apple Developer Forums - Programmatic Focus Activation](https://developer.apple.com/forums/thread/729475)
3. [Apple Developer Forums - Focus Status API](https://developer.apple.com/forums/thread/682143)
4. [GitHub - macos-focus-mode](https://github.com/arodik/macos-focus-mode)
5. [GitHub - JXA Focus Mode Reader](https://gist.github.com/drewkerr/0f2b61ce34e2b9e3ce0ec6a92ab05c18)
6. [FileMinutes - macOS Focus Mode Guide (2025)](https://www.fileminutes.com/blog/everything-you-need-to-know-about-macos-focus-mode-2025/)
7. [Automators Talk - Set Focus Mode on macOS](https://talk.automators.fm/t/set-focus-mode-on-macos/13170)
8. [MacPowerUsers - Can Shortcuts Tell Focus Mode Status](https://talk.macpowerusers.com/t/can-shortcuts-tell-you-a-focus-mode-is-enabled-and-ideally-which-one/25922)

---

**Research completed by**: Claude Code
**Date**: 2026-02-24
