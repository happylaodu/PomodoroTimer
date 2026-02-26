#!/bin/bash

# Generate UUIDs for the new file
FILE_REF_UUID=$(uuidgen | tr '[:upper:]' '[:lower:]' | tr -d '-' | cut -c1-24 | tr '[:lower:]' '[:upper:]')
BUILD_FILE_UUID=$(uuidgen | tr '[:upper:]' '[:lower:]' | tr -d '-' | cut -c1-24 | tr '[:lower:]' '[:upper:]')

echo "Generated UUIDs:"
echo "FILE_REF: $FILE_REF_UUID"
echo "BUILD_FILE: $BUILD_FILE_UUID"

# Backup project file
cp PomodoroTimer.xcodeproj/project.pbxproj PomodoroTimer.xcodeproj/project.pbxproj.backup

# Add file reference (in PBXFileReference section)
perl -i -pe "if (/\/\* StatusBarController\.swift \*\/;$/) { 
    print; 
    print \"\t\t$FILE_REF_UUID /* KeyboardShortcutManager.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = KeyboardShortcutManager.swift; sourceTree = \\\"<group>\\\"; };\n\";
    \$_ = '';
}" PomodoroTimer.xcodeproj/project.pbxproj

# Add build file (in PBXBuildFile section)
perl -i -pe "if (/\/\* StatusBarController\.swift in Sources \*\/;$/) {
    print;
    print \"\t\t$BUILD_FILE_UUID /* KeyboardShortcutManager.swift in Sources */ = {isa = PBXBuildFile; fileRef = $FILE_REF_UUID /* KeyboardShortcutManager.swift */; };\n\";
    \$_ = '';
}" PomodoroTimer.xcodeproj/project.pbxproj

# Add to group (in PBXGroup section for PomodoroTimer folder)
perl -i -pe "if (/00D3E5542C403F4F00E4E79B \/\* StatusBarController\.swift \*\/,/) {
    print;
    print \"\t\t\t\t$FILE_REF_UUID /* KeyboardShortcutManager.swift */,\n\";
    \$_ = '';
}" PomodoroTimer.xcodeproj/project.pbxproj

# Add to sources build phase (in PBXSourcesBuildPhase section)
perl -i -pe "if (/00D3E5552C403F4F00E4E79B \/\* StatusBarController\.swift in Sources \*\/,/) {
    print;
    print \"\t\t\t\t$BUILD_FILE_UUID /* KeyboardShortcutManager.swift in Sources */,\n\";
    \$_ = '';
}" PomodoroTimer.xcodeproj/project.pbxproj

echo "✅ Added KeyboardShortcutManager.swift to Xcode project"
