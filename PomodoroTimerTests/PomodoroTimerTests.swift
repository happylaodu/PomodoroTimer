//
//  PomodoroTimerTests.swift
//  PomodoroTimerTests
//
//  Created by happylaodu on 2025-07-11.
//

import Testing
@testable import PomodoroTimer
import Foundation

struct PomodoroTimerTests {

    @Test("Long rest logic: rounds 1-3 are short, round 4 is long")
    func testLongRestLogic() async throws {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "completedRounds")

        let timer = PomodoroTimer()

        // Simulate the flow in tick():
        // completedRounds increments first, then check if it's long rest

        // After completing 1st work session
        timer.completedRounds = 1
        #expect(!timer.isLongRest, "After 1 round: should be short rest")

        // After completing 2nd work session
        timer.completedRounds = 2
        #expect(!timer.isLongRest, "After 2 rounds: should be short rest")

        // After completing 3rd work session
        timer.completedRounds = 3
        #expect(!timer.isLongRest, "After 3 rounds: should be short rest")

        // After completing 4th work session - THIS IS THE KEY TEST
        timer.completedRounds = 4
        #expect(timer.isLongRest, "After 4 rounds: should be LONG rest")

        // After completing 5th work session
        timer.completedRounds = 5
        #expect(!timer.isLongRest, "After 5 rounds: should be short rest again")

        // After completing 8th work session
        timer.completedRounds = 8
        #expect(timer.isLongRest, "After 8 rounds: should be LONG rest again")

        defaults.removeObject(forKey: "completedRounds")
    }

    @Test("incrementWorkCounters resets completedRounds on new day")
    func testIncrementWorkCountersDateCheck() async throws {
        let defaults = UserDefaults.standard

        // Clear all test-related keys
        for key in ["dailyWorkSessions", "completedRounds", "lastWorkDate",
                    "weeklyWorkSessions", "totalWorkSessions", "dailyHistory"] {
            defaults.removeObject(forKey: key)
        }

        // Set today as lastWorkDate
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        let todayString = formatter.string(from: Date())

        defaults.set(todayString, forKey: "lastWorkDate")
        defaults.set(3, forKey: "completedRounds")
        defaults.set(5, forKey: "dailyWorkSessions")

        let timer = PomodoroTimer()

        // Simulate day change by setting lastWorkDate to yesterday
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let yesterdayString = formatter.string(from: yesterday)
        defaults.set(yesterdayString, forKey: "lastWorkDate")

        // Call incrementWorkCounters
        timer.incrementWorkCounters()

        // KEY ASSERTION: completedRounds should be reset to 0
        #expect(timer.completedRounds == 0,
                "completedRounds must reset to 0 when day changes (was 3, now \(timer.completedRounds))")

        // Also verify dailyWorkSessions was reset and incremented
        #expect(timer.dailyWorkSessions == 1,
                "dailyWorkSessions should be reset to 0 then incremented to 1 (now \(timer.dailyWorkSessions))")

        // Cleanup
        for key in ["dailyWorkSessions", "completedRounds", "lastWorkDate",
                    "weeklyWorkSessions", "totalWorkSessions", "dailyHistory"] {
            defaults.removeObject(forKey: key)
        }
    }

    @Test("Bug scenario simulation: 3 rounds yesterday shouldn't cause early long rest")
    func testBugScenario() async throws {
        // This test verifies the real-world bug scenario:
        // - User completed 3 rounds yesterday
        // - Computer didn't shut down overnight
        // - Today, first round incorrectly showed as long rest
        //
        // The fix ensures completedRounds resets to 0 on a new day

        // Verify the core logic works correctly
        let timer = PomodoroTimer()

        // Assume yesterday was 3 rounds (we can't easily test the full scenario
        // due to UserDefaults and init() complexity in unit tests)

        // The key test: After resetting to 0, first round should be short rest
        timer.completedRounds = 0  // This is what should happen after date reset
        timer.completedRounds += 1  // Complete first work session

        // After 1 round, it should NOT be long rest
        #expect(!timer.isLongRest,
                "After 1 round (first of the day), should be SHORT rest, not long")

        // After 4 rounds, it SHOULD be long rest
        timer.completedRounds = 4
        #expect(timer.isLongRest,
                "After 4 rounds, should be LONG rest")
    }
}
