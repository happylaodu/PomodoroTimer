#!/bin/bash

# This script adds the localization files to the Xcode project

echo "Adding localization files to Xcode project..."

# Add English localization files
echo "Adding en.lproj/Localizable.strings..."
xcodebuild -project PomodoroTimer.xcodeproj -scheme PomodoroTimer -list 2>&1 | grep -q "PomodoroTimer" && echo "Project found"

# Note: Xcodebuild doesn't have a direct command to add files
# The user needs to do this manually in Xcode or we need to edit the pbxproj file

echo ""
echo "=========================================="
echo "MANUAL STEPS REQUIRED IN XCODE:"
echo "=========================================="
echo ""
echo "1. Open PomodoroTimer.xcodeproj in Xcode"
echo ""
echo "2. Add Simplified Chinese to the project:"
echo "   - Click on the project in the left sidebar (PomodoroTimer)"
echo "   - Select the PomodoroTimer target"
echo "   - Go to the 'Info' tab"
echo "   - Under 'Localizations', click the '+' button"
echo "   - Select 'Chinese (Simplified)' [zh-Hans]"
echo "   - Click 'Finish' (don't select any files in the dialog)"
echo ""
echo "3. Add the Localizable.strings files to the project:"
echo "   - Right-click on 'PomodoroTimer' folder in the left sidebar"
echo "   - Select 'Add Files to \"PomodoroTimer\"...'"
echo "   - Navigate to PomodoroTimer/en.lproj/"
echo "   - Select Localizable.strings"
echo "   - Make sure 'Copy items if needed' is UNCHECKED"
echo "   - Make sure 'Create groups' is selected"
echo "   - Click 'Add'"
echo ""
echo "   - Repeat for PomodoroTimer/zh-Hans.lproj/Localizable.strings"
echo ""
echo "4. Verify the localization:"
echo "   - Select either Localizable.strings file in the project navigator"
echo "   - In the File Inspector (right sidebar), you should see:"
echo "     ✓ Localize... button (or already localized)"
echo "     ✓ Both English and Chinese (Simplified) checkboxes"
echo ""
echo "5. Build and test:"
echo "   - Press Cmd+B to build"
echo "   - Change your Mac's language to Chinese in System Preferences"
echo "   - Run the app to see Chinese UI"
echo ""
echo "=========================================="

