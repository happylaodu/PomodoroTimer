#!/bin/bash
echo "helllo"
# 1. 找到 Info.plist 路径（修改为你的项目路径）
PLIST_FILE="./PomodoroTimer/Info.plist"

# 2. 读取当前 Build Number
CURRENT_BUILD=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$PLIST_FILE")

# 3. 计算新 Build Number
NEW_BUILD=$((CURRENT_BUILD + 1))

# 4. 写入新的 Build Number
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $NEW_BUILD" "$PLIST_FILE"

# 5. 输出结果
echo "✅ Build number updated: $CURRENT_BUILD → $NEW_BUILD"
