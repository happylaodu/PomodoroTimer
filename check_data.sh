#!/bin/bash
# Quick check of Pomodoro Timer UserDefaults data

BUNDLE_ID="com.brightjune.PomodoroTimer"

echo "📊 Pomodoro Timer Data:"
echo ""
echo "Today's sessions:    $(defaults read $BUNDLE_ID dailyWorkSessions 2>/dev/null || echo 'not set')"
echo "Total sessions:      $(defaults read $BUNDLE_ID totalWorkSessions 2>/dev/null || echo 'not set')"
echo "Completed rounds:    $(defaults read $BUNDLE_ID completedRounds 2>/dev/null || echo 'not set')"
echo "Last work date:      $(defaults read $BUNDLE_ID lastWorkDate 2>/dev/null || echo 'not set')"
echo ""

# Check if dailyHistory exists
if defaults read $BUNDLE_ID dailyHistory &>/dev/null; then
    echo "✅ dailyHistory exists (binary data)"
else
    echo "❌ dailyHistory not set"
fi
