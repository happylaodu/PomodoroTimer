import Foundation
import AppKit
import PDFKit

class StatisticsExporter {

    // MARK: - CSV Export

    /// Export all statistics to CSV format
    static func exportToCSV(dailyHistory: [String: Int], totalSessions: Int) -> String {
        var csv = "Date,Sessions,Cumulative Total\n"

        // Sort dates chronologically
        let sortedHistory = dailyHistory.sorted { $0.key < $1.key }

        var cumulative = 0
        for (date, count) in sortedHistory {
            cumulative += count
            csv += "\(date),\(count),\(cumulative)\n"
        }

        return csv
    }

    /// Save CSV to file with save panel
    static func saveCSVToFile(dailyHistory: [String: Int], totalSessions: Int) {
        let csv = exportToCSV(dailyHistory: dailyHistory, totalSessions: totalSessions)

        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.commaSeparatedText]
        savePanel.nameFieldStringValue = "pomodoro_statistics_\(currentDateString()).csv"
        savePanel.title = "Export Statistics to CSV"

        savePanel.begin { response in
            if response == .OK, let url = savePanel.url {
                do {
                    try csv.write(to: url, atomically: true, encoding: .utf8)
                    showAlert(title: "Export Successful", message: "Statistics exported to \(url.lastPathComponent)")
                } catch {
                    showAlert(title: "Export Failed", message: error.localizedDescription)
                }
            }
        }
    }

    // MARK: - PDF Export

    /// Generate PDF report
    static func exportToPDF(dailyHistory: [String: Int], totalSessions: Int, reportType: ReportType) {
        let pdfData = generatePDFData(dailyHistory: dailyHistory, totalSessions: totalSessions, reportType: reportType)

        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.pdf]
        savePanel.nameFieldStringValue = "pomodoro_\(reportType.rawValue)_report_\(currentDateString()).pdf"
        savePanel.title = "Export \(reportType.displayName) Report"

        savePanel.begin { response in
            if response == .OK, let url = savePanel.url {
                do {
                    try pdfData.write(to: url)
                    showAlert(title: "Export Successful", message: "Report exported to \(url.lastPathComponent)")
                } catch {
                    showAlert(title: "Export Failed", message: error.localizedDescription)
                }
            }
        }
    }

    /// Generate PDF data
    private static func generatePDFData(dailyHistory: [String: Int], totalSessions: Int, reportType: ReportType) -> Data {
        let pdfData = NSMutableData()
        var pageRect = CGRect(x: 0, y: 0, width: 612, height: 792) // US Letter size

        guard let pdfConsumer = CGDataConsumer(data: pdfData as CFMutableData),
              let pdfContext = CGContext(consumer: pdfConsumer, mediaBox: nil, nil) else {
            return Data()
        }

        pdfContext.beginPage(mediaBox: &pageRect)

        let title = "\(reportType.displayName) Report"
        let reportData = filterDataByReportType(dailyHistory: dailyHistory, reportType: reportType)

        drawPDFContent(
            context: pdfContext,
            in: pageRect,
            title: title,
            data: reportData,
            totalSessions: totalSessions
        )

        pdfContext.endPage()
        pdfContext.closePDF()

        return pdfData as Data
    }

    /// Draw PDF content
    private static func drawPDFContent(context: CGContext, in rect: CGRect, title: String, data: [(String, Int)], totalSessions: Int) {
        let titleFont = NSFont.boldSystemFont(ofSize: 24)
        let headingFont = NSFont.boldSystemFont(ofSize: 16)
        let bodyFont = NSFont.systemFont(ofSize: 12)

        var yPosition: CGFloat = 50

        // Title
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: NSColor.black
        ]
        drawText(context: context, text: title, attributes: titleAttributes, at: CGPoint(x: 50, y: yPosition), pageHeight: rect.height)
        yPosition += 40

        // Date range
        let dateRange = "Generated: \(currentDateString())"
        let dateAttributes: [NSAttributedString.Key: Any] = [
            .font: bodyFont,
            .foregroundColor: NSColor.gray
        ]
        drawText(context: context, text: dateRange, attributes: dateAttributes, at: CGPoint(x: 50, y: yPosition), pageHeight: rect.height)
        yPosition += 30

        // Summary section
        let summaryTitle = "Summary"
        let summaryAttributes: [NSAttributedString.Key: Any] = [
            .font: headingFont,
            .foregroundColor: NSColor.black
        ]
        drawText(context: context, text: summaryTitle, attributes: summaryAttributes, at: CGPoint(x: 50, y: yPosition), pageHeight: rect.height)
        yPosition += 25

        // Statistics
        let stats = calculateStatistics(data: data, totalSessions: totalSessions)
        let bodyAttributes: [NSAttributedString.Key: Any] = [
            .font: bodyFont,
            .foregroundColor: NSColor.black
        ]

        for line in stats {
            drawText(context: context, text: line, attributes: bodyAttributes, at: CGPoint(x: 70, y: yPosition), pageHeight: rect.height)
            yPosition += 20
        }

        yPosition += 20

        // Daily breakdown
        let breakdownTitle = "Daily Breakdown"
        drawText(context: context, text: breakdownTitle, attributes: summaryAttributes, at: CGPoint(x: 50, y: yPosition), pageHeight: rect.height)
        yPosition += 25

        // Table header
        drawText(context: context, text: "Date                    Sessions", attributes: bodyAttributes, at: CGPoint(x: 70, y: yPosition), pageHeight: rect.height)
        yPosition += 20

        // Table rows
        for (date, count) in data {
            let rowText = "\(date)         \(count)"
            drawText(context: context, text: rowText, attributes: bodyAttributes, at: CGPoint(x: 70, y: yPosition), pageHeight: rect.height)
            yPosition += 18

            // Stop if we run out of space
            if yPosition > rect.height - 50 {
                break
            }
        }
    }

    /// Helper to draw text in PDF context
    private static func drawText(context: CGContext, text: String, attributes: [NSAttributedString.Key: Any], at point: CGPoint, pageHeight: CGFloat) {
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        let line = CTLineCreateWithAttributedString(attributedString)

        // Convert from top-left origin to bottom-left origin (PDF coordinate system)
        let pdfY = pageHeight - point.y
        context.textPosition = CGPoint(x: point.x, y: pdfY)
        CTLineDraw(line, context)
    }

    /// Calculate statistics for report
    private static func calculateStatistics(data: [(String, Int)], totalSessions: Int) -> [String] {
        let sessionCount = data.reduce(0) { $0 + $1.1 }
        let days = data.count
        let avgPerDay = days > 0 ? Double(sessionCount) / Double(days) : 0.0
        let maxDay = data.max { $0.1 < $1.1 }

        var stats: [String] = []
        stats.append("• Total sessions in period: \(sessionCount)")
        stats.append("• Number of days: \(days)")
        stats.append("• Average sessions per day: \(String(format: "%.1f", avgPerDay))")

        if let max = maxDay {
            stats.append("• Most productive day: \(max.0) (\(max.1) sessions)")
        }

        stats.append("• All-time total sessions: \(totalSessions)")

        return stats
    }

    // MARK: - Report Filtering

    enum ReportType: String {
        case weekly = "weekly"
        case monthly = "monthly"
        case all = "all"

        var displayName: String {
            switch self {
            case .weekly: return "Weekly"
            case .monthly: return "Monthly"
            case .all: return "All-Time"
            }
        }
    }

    /// Filter data by report type
    private static func filterDataByReportType(dailyHistory: [String: Int], reportType: ReportType) -> [(String, Int)] {
        let calendar = Calendar.current
        let now = Date()

        let filtered: [String: Int]

        switch reportType {
        case .weekly:
            // Last 7 days
            let weekAgo = calendar.date(byAdding: .day, value: -7, to: now)!
            filtered = dailyHistory.filter { dateStr, _ in
                if let date = dateFromString(dateStr) {
                    return date >= weekAgo
                }
                return false
            }

        case .monthly:
            // Last 30 days
            let monthAgo = calendar.date(byAdding: .day, value: -30, to: now)!
            filtered = dailyHistory.filter { dateStr, _ in
                if let date = dateFromString(dateStr) {
                    return date >= monthAgo
                }
                return false
            }

        case .all:
            filtered = dailyHistory
        }

        return filtered.sorted { $0.key < $1.key }
    }

    // MARK: - Helpers

    private static func currentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }

    private static func dateFromString(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: string)
    }

    private static func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = title
            alert.informativeText = message
            alert.alertStyle = .informational
            alert.addButton(withTitle: "OK")
            alert.runModal()
        }
    }
}
