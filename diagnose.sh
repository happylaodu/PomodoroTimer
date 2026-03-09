#!/bin/bash
# Diagnose Pomodoro Timer data issues

BUNDLE_ID="com.brightjune.PomodoroTimer"

echo "🔍 Pomodoro Timer Diagnostics"
echo "=============================="
echo ""

echo "1️⃣ Plist file check:"
PLIST="$HOME/Library/Preferences/$BUNDLE_ID.plist"
if [ -f "$PLIST" ]; then
    echo "   ✅ Plist exists: $PLIST"
    echo ""
    echo "   Values in plist:"
    plutil -p "$PLIST" | grep -E "dailyWorkSessions|totalWorkSessions|lastWorkDate|dailyHistory" | head -5
else
    echo "   ❌ Plist not found"
fi

echo ""
echo "2️⃣ UserDefaults.standard check (from command line):"
swift << 'EOF'
import Foundation
let d = UserDefaults.standard
print("   dailyWorkSessions: \(d.integer(forKey: "dailyWorkSessions"))")
print("   totalWorkSessions: \(d.integer(forKey: "totalWorkSessions"))")
print("   lastWorkDate: \(d.string(forKey: "lastWorkDate") ?? "nil")")
print("   dailyHistory: \(d.data(forKey: "dailyHistory") != nil ? "exists" : "nil")")
EOF

echo ""
echo "3️⃣ App domain check:"
swift << EOF
import Foundation
let d = UserDefaults(suiteName: "$BUNDLE_ID")!
print("   dailyWorkSessions: \(d.integer(forKey: "dailyWorkSessions"))")
print("   totalWorkSessions: \(d.integer(forKey: "totalWorkSessions"))")
print("   lastWorkDate: \(d.string(forKey: "lastWorkDate") ?? "nil")")
if let data = d.data(forKey: "dailyHistory"),
   let hist = try? JSONDecoder().decode([String: Int].self, from: data) {
    print("   dailyHistory: \(hist.count) days loaded")
} else {
    print("   dailyHistory: nil or decode failed")
}
EOF

echo ""
echo "4️⃣ Process check:"
if pgrep -x "PomodoroTimer" > /dev/null; then
    echo "   ✅ App is running (PID: $(pgrep -x "PomodoroTimer"))"
else
    echo "   ⚠️  App is not running"
fi
