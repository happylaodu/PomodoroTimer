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

        let title = "\(reportType.displayName) Report"
        let reportData = filterDataByReportType(dailyHistory: dailyHistory, reportType: reportType)

        drawPDFContentWithPagination(
            context: pdfContext,
            pageRect: &pageRect,
            title: title,
            data: reportData,
            totalSessions: totalSessions,
            reportType: reportType
        )

        pdfContext.closePDF()

        return pdfData as Data
    }

    /// Draw PDF content with pagination support
    private static func drawPDFContentWithPagination(context: CGContext, pageRect: inout CGRect, title: String, data: [(String, Int)], totalSessions: Int, reportType: ReportType) {
        let bodyFont = NSFont.systemFont(ofSize: 12)
        let bodyAttributes: [NSAttributedString.Key: Any] = [
            .font: bodyFont,
            .foregroundColor: NSColor.black
        ]

        // Draw first page with header, summary, and chart
        context.beginPage(mediaBox: &pageRect)
        var yPosition = drawPDFHeader(context: context, in: pageRect, title: title)
        yPosition = drawPDFSummary(context: context, yPosition: yPosition, pageHeight: pageRect.height, data: data, totalSessions: totalSessions)
        yPosition = drawPDFChart(context: context, yPosition: yPosition, pageHeight: pageRect.height, pageWidth: pageRect.width, data: data)

        // Add weekly chart for monthly/all-time reports with >7 days of data
        if (reportType == .monthly || reportType == .all) && data.count > 7 {
            let weeklyData = aggregateDataByWeek(data: data)
            if !weeklyData.isEmpty {
                // Check if we need a new page
                if yPosition > pageRect.height - 250 {
                    context.endPage()
                    context.beginPage(mediaBox: &pageRect)
                    yPosition = 50
                }
                yPosition = drawWeeklyChart(context: context, yPosition: yPosition, pageHeight: pageRect.height, pageWidth: pageRect.width, weeklyData: weeklyData)
            }
        }

        // Check if we have enough space for table header + at least 3 rows (approx 100 points)
        // If not, start table on new page
        if yPosition > pageRect.height - 120 {
            context.endPage()
            context.beginPage(mediaBox: &pageRect)
            yPosition = 50
        }

        // Draw table header
        yPosition = drawTableHeader(context: context, yPosition: yPosition, pageHeight: pageRect.height)

        // Draw table rows with pagination
        var currentRow = 0
        while currentRow < data.count {
            // Check if we need a new page
            if yPosition > pageRect.height - 70 {
                context.endPage()
                context.beginPage(mediaBox: &pageRect)
                yPosition = 50
                yPosition = drawTableHeader(context: context, yPosition: yPosition, pageHeight: pageRect.height)
            }

            let (date, count) = data[currentRow]
            let rowText = "\(date)         \(count)"
            drawText(context: context, text: rowText, attributes: bodyAttributes, at: CGPoint(x: 70, y: yPosition), pageHeight: pageRect.height)
            yPosition += 18
            currentRow += 1
        }

        context.endPage()
    }

    /// Draw PDF header (title and date)
    private static func drawPDFHeader(context: CGContext, in rect: CGRect, title: String) -> CGFloat {
        let titleFont = NSFont.boldSystemFont(ofSize: 24)
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

        return yPosition
    }

    /// Draw PDF summary section
    private static func drawPDFSummary(context: CGContext, yPosition: CGFloat, pageHeight: CGFloat, data: [(String, Int)], totalSessions: Int) -> CGFloat {
        let headingFont = NSFont.boldSystemFont(ofSize: 16)
        let bodyFont = NSFont.systemFont(ofSize: 12)

        var y = yPosition

        // Summary section
        let summaryTitle = "Summary"
        let summaryAttributes: [NSAttributedString.Key: Any] = [
            .font: headingFont,
            .foregroundColor: NSColor.black
        ]
        drawText(context: context, text: summaryTitle, attributes: summaryAttributes, at: CGPoint(x: 50, y: y), pageHeight: pageHeight)
        y += 25

        // Statistics
        let stats = calculateStatistics(data: data, totalSessions: totalSessions)
        let bodyAttributes: [NSAttributedString.Key: Any] = [
            .font: bodyFont,
            .foregroundColor: NSColor.black
        ]

        for line in stats {
            drawText(context: context, text: line, attributes: bodyAttributes, at: CGPoint(x: 70, y: y), pageHeight: pageHeight)
            y += 20
        }

        y += 20
        return y
    }

    /// Draw PDF chart section
    private static func drawPDFChart(context: CGContext, yPosition: CGFloat, pageHeight: CGFloat, pageWidth: CGFloat, data: [(String, Int)]) -> CGFloat {
        let headingFont = NSFont.boldSystemFont(ofSize: 16)
        let summaryAttributes: [NSAttributedString.Key: Any] = [
            .font: headingFont,
            .foregroundColor: NSColor.black
        ]

        var y = yPosition

        // Chart
        let chartTitle = "Activity Chart"
        drawText(context: context, text: chartTitle, attributes: summaryAttributes, at: CGPoint(x: 50, y: y), pageHeight: pageHeight)
        y += 25

        let chartHeight: CGFloat = 180
        let chartWidth: CGFloat = pageWidth - 100
        drawBarChart(context: context, data: data, rect: CGRect(x: 50, y: y, width: chartWidth, height: chartHeight), pageHeight: pageHeight)
        y += chartHeight + 30

        return y
    }

    /// Draw table header
    private static func drawTableHeader(context: CGContext, yPosition: CGFloat, pageHeight: CGFloat) -> CGFloat {
        let headingFont = NSFont.boldSystemFont(ofSize: 16)
        let bodyFont = NSFont.systemFont(ofSize: 12)

        var y = yPosition

        // Daily breakdown title
        let breakdownTitle = "Daily Breakdown"
        let summaryAttributes: [NSAttributedString.Key: Any] = [
            .font: headingFont,
            .foregroundColor: NSColor.black
        ]
        drawText(context: context, text: breakdownTitle, attributes: summaryAttributes, at: CGPoint(x: 50, y: y), pageHeight: pageHeight)
        y += 25

        // Table header
        let bodyAttributes: [NSAttributedString.Key: Any] = [
            .font: bodyFont,
            .foregroundColor: NSColor.black
        ]
        drawText(context: context, text: "Date                    Sessions", attributes: bodyAttributes, at: CGPoint(x: 70, y: y), pageHeight: pageHeight)
        y += 20

        return y
    }

    /// Draw PDF content (legacy single page - kept for compatibility)
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

        // Chart
        let chartTitle = "Activity Chart"
        drawText(context: context, text: chartTitle, attributes: summaryAttributes, at: CGPoint(x: 50, y: yPosition), pageHeight: rect.height)
        yPosition += 25

        let chartHeight: CGFloat = 180
        let chartWidth: CGFloat = rect.width - 100
        drawBarChart(context: context, data: data, rect: CGRect(x: 50, y: yPosition, width: chartWidth, height: chartHeight), pageHeight: rect.height)
        yPosition += chartHeight + 30

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

    /// Draw bar chart in PDF context
    private static func drawBarChart(context: CGContext, data: [(String, Int)], rect: CGRect, pageHeight: CGFloat) {
        guard !data.isEmpty else { return }

        // Convert to PDF coordinates (bottom-left origin)
        let pdfRect = CGRect(
            x: rect.origin.x,
            y: pageHeight - rect.origin.y - rect.height,
            width: rect.width,
            height: rect.height
        )

        // Chart margins
        let leftMargin: CGFloat = 40
        let rightMargin: CGFloat = 20
        let bottomMargin: CGFloat = 50
        let topMargin: CGFloat = 20

        let chartArea = CGRect(
            x: pdfRect.origin.x + leftMargin,
            y: pdfRect.origin.y + bottomMargin,
            width: pdfRect.width - leftMargin - rightMargin,
            height: pdfRect.height - bottomMargin - topMargin
        )

        // Find max value for scaling
        let maxValue = data.max { $0.1 < $1.1 }?.1 ?? 1

        // Calculate bar width and spacing
        let barCount = CGFloat(data.count)
        let totalSpacing = chartArea.width * 0.1
        let barSpacing = totalSpacing / max(barCount - 1, 1)
        let barWidth = (chartArea.width - totalSpacing) / barCount

        // Draw bars
        context.saveGState()
        for (index, item) in data.enumerated() {
            let (_, count) = item
            let barHeight = chartArea.height * CGFloat(count) / CGFloat(maxValue)
            let x = chartArea.origin.x + CGFloat(index) * (barWidth + barSpacing)
            let y = chartArea.origin.y

            let barRect = CGRect(x: x, y: y, width: barWidth, height: barHeight)

            // Draw bar with blue color (matching in-app chart)
            context.setFillColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 0.8)
            context.fill(barRect)

            // Draw value on top of bar
            if count > 0 {
                let valueText = "\(count)"
                let valueAttributes: [NSAttributedString.Key: Any] = [
                    .font: NSFont.systemFont(ofSize: 9),
                    .foregroundColor: NSColor.black
                ]
                let valueString = NSAttributedString(string: valueText, attributes: valueAttributes)
                let valueLine = CTLineCreateWithAttributedString(valueString)
                let valueSize = CTLineGetBoundsWithOptions(valueLine, .useOpticalBounds).size

                let valueX = x + (barWidth - valueSize.width) / 2
                let valueY = y + barHeight + 3

                context.textPosition = CGPoint(x: valueX, y: valueY)
                CTLineDraw(valueLine, context)
            }
        }
        context.restoreGState()

        // Draw axes
        context.saveGState()
        context.setStrokeColor(gray: 0.6, alpha: 1.0)
        context.setLineWidth(1.0)

        // Y-axis
        context.move(to: CGPoint(x: chartArea.origin.x, y: chartArea.origin.y))
        context.addLine(to: CGPoint(x: chartArea.origin.x, y: chartArea.origin.y + chartArea.height))

        // X-axis
        context.move(to: CGPoint(x: chartArea.origin.x, y: chartArea.origin.y))
        context.addLine(to: CGPoint(x: chartArea.origin.x + chartArea.width, y: chartArea.origin.y))

        context.strokePath()
        context.restoreGState()

        // Draw date labels
        context.saveGState()
        let labelAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 8),
            .foregroundColor: NSColor.darkGray
        ]

        for (index, item) in data.enumerated() {
            let (dateStr, _) = item
            let x = chartArea.origin.x + CGFloat(index) * (barWidth + barSpacing)

            // Extract month/day from date string (YYYY-MM-DD)
            let components = dateStr.split(separator: "-")
            let labelText = components.count >= 3 ? "\(components[1])/\(components[2])" : dateStr

            let labelString = NSAttributedString(string: labelText, attributes: labelAttributes)
            let labelLine = CTLineCreateWithAttributedString(labelString)
            let labelSize = CTLineGetBoundsWithOptions(labelLine, .useOpticalBounds).size

            // Rotate label for better readability
            context.saveGState()
            let labelX = x + barWidth / 2 + 4  // Shift right slightly to align with bar center
            let labelY = chartArea.origin.y - 20  // Move down to avoid overlap

            context.translateBy(x: labelX, y: labelY)
            context.rotate(by: -CGFloat.pi / 4)

            context.textPosition = CGPoint(x: -labelSize.width / 2, y: 0)  // Center the rotated text
            CTLineDraw(labelLine, context)
            context.restoreGState()
        }
        context.restoreGState()

        // Draw Y-axis labels
        context.saveGState()
        let yLabelAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 9),
            .foregroundColor: NSColor.darkGray
        ]

        let ySteps = 4
        for i in 0...ySteps {
            let value = (maxValue * i) / ySteps
            let y = chartArea.origin.y + (chartArea.height * CGFloat(i)) / CGFloat(ySteps)

            // Draw grid line
            context.setStrokeColor(gray: 0.9, alpha: 1.0)
            context.setLineWidth(0.5)
            context.move(to: CGPoint(x: chartArea.origin.x, y: y))
            context.addLine(to: CGPoint(x: chartArea.origin.x + chartArea.width, y: y))
            context.strokePath()

            // Draw label
            let labelText = "\(value)"
            let labelString = NSAttributedString(string: labelText, attributes: yLabelAttributes)
            let labelLine = CTLineCreateWithAttributedString(labelString)
            let labelSize = CTLineGetBoundsWithOptions(labelLine, .useOpticalBounds).size

            context.textPosition = CGPoint(x: chartArea.origin.x - labelSize.width - 5, y: y - labelSize.height / 2)
            CTLineDraw(labelLine, context)
        }
        context.restoreGState()
    }

    /// Aggregate daily data by week (week starts on Sunday)
    private static func aggregateDataByWeek(data: [(String, Int)]) -> [(String, Int)] {
        var weeklyData: [String: Int] = [:]
        let calendar = Calendar.current

        for (dateStr, count) in data {
            guard let date = dateFromString(dateStr) else { continue }

            // Get the Sunday of the week containing this date
            let weekday = calendar.component(.weekday, from: date)
            let daysToSubtract = weekday - 1  // Sunday is 1, so subtract (weekday - 1) days
            guard let weekStart = calendar.date(byAdding: .day, value: -daysToSubtract, to: date) else { continue }

            let weekKey = formattedDate(weekStart)
            weeklyData[weekKey, default: 0] += count
        }

        return weeklyData.sorted { $0.key < $1.key }
    }

    /// Draw weekly overview chart
    private static func drawWeeklyChart(context: CGContext, yPosition: CGFloat, pageHeight: CGFloat, pageWidth: CGFloat, weeklyData: [(String, Int)]) -> CGFloat {
        let headingFont = NSFont.boldSystemFont(ofSize: 16)
        let summaryAttributes: [NSAttributedString.Key: Any] = [
            .font: headingFont,
            .foregroundColor: NSColor.black
        ]

        var y = yPosition

        // Chart title
        let chartTitle = "Weekly Overview"
        drawText(context: context, text: chartTitle, attributes: summaryAttributes, at: CGPoint(x: 50, y: y), pageHeight: pageHeight)
        y += 25

        let chartHeight: CGFloat = 180
        let chartWidth: CGFloat = pageWidth - 100
        drawWeeklyBarChart(context: context, data: weeklyData, rect: CGRect(x: 50, y: y, width: chartWidth, height: chartHeight), pageHeight: pageHeight)
        y += chartHeight + 30

        return y
    }

    /// Draw weekly bar chart
    private static func drawWeeklyBarChart(context: CGContext, data: [(String, Int)], rect: CGRect, pageHeight: CGFloat) {
        guard !data.isEmpty else { return }

        // Convert to PDF coordinates (bottom-left origin)
        let pdfRect = CGRect(
            x: rect.origin.x,
            y: pageHeight - rect.origin.y - rect.height,
            width: rect.width,
            height: rect.height
        )

        // Chart margins
        let leftMargin: CGFloat = 50
        let rightMargin: CGFloat = 20
        let bottomMargin: CGFloat = 50
        let topMargin: CGFloat = 20

        let chartArea = CGRect(
            x: pdfRect.origin.x + leftMargin,
            y: pdfRect.origin.y + bottomMargin,
            width: pdfRect.width - leftMargin - rightMargin,
            height: pdfRect.height - bottomMargin - topMargin
        )

        // Find max value for scaling
        let maxValue = data.max { $0.1 < $1.1 }?.1 ?? 1

        // Calculate bar width and spacing
        let barCount = CGFloat(data.count)
        let totalSpacing = chartArea.width * 0.1
        let barSpacing = totalSpacing / max(barCount - 1, 1)
        let barWidth = (chartArea.width - totalSpacing) / barCount

        // Draw bars
        context.saveGState()
        for (index, item) in data.enumerated() {
            let (_, count) = item
            let barHeight = chartArea.height * CGFloat(count) / CGFloat(maxValue)
            let x = chartArea.origin.x + CGFloat(index) * (barWidth + barSpacing)
            let y = chartArea.origin.y

            let barRect = CGRect(x: x, y: y, width: barWidth, height: barHeight)

            // Draw bar with green color for weekly data
            context.setFillColor(red: 0.2, green: 0.78, blue: 0.35, alpha: 0.8)
            context.fill(barRect)

            // Draw value on top of bar
            if count > 0 {
                let valueText = "\(count)"
                let valueAttributes: [NSAttributedString.Key: Any] = [
                    .font: NSFont.systemFont(ofSize: 9),
                    .foregroundColor: NSColor.black
                ]
                let valueString = NSAttributedString(string: valueText, attributes: valueAttributes)
                let valueLine = CTLineCreateWithAttributedString(valueString)
                let valueSize = CTLineGetBoundsWithOptions(valueLine, .useOpticalBounds).size

                let valueX = x + (barWidth - valueSize.width) / 2
                let valueY = y + barHeight + 3

                context.textPosition = CGPoint(x: valueX, y: valueY)
                CTLineDraw(valueLine, context)
            }
        }
        context.restoreGState()

        // Draw axes
        context.saveGState()
        context.setStrokeColor(gray: 0.6, alpha: 1.0)
        context.setLineWidth(1.0)

        // Y-axis
        context.move(to: CGPoint(x: chartArea.origin.x, y: chartArea.origin.y))
        context.addLine(to: CGPoint(x: chartArea.origin.x, y: chartArea.origin.y + chartArea.height))

        // X-axis
        context.move(to: CGPoint(x: chartArea.origin.x, y: chartArea.origin.y))
        context.addLine(to: CGPoint(x: chartArea.origin.x + chartArea.width, y: chartArea.origin.y))

        context.strokePath()
        context.restoreGState()

        // Draw week labels
        context.saveGState()
        let labelAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 8),
            .foregroundColor: NSColor.darkGray
        ]

        let calendar = Calendar.current
        for (index, item) in data.enumerated() {
            let (dateStr, _) = item
            let x = chartArea.origin.x + CGFloat(index) * (barWidth + barSpacing)

            // Format as "Week of MM/DD"
            var labelText = ""
            if let date = dateFromString(dateStr) {
                let components = calendar.dateComponents([.month, .day], from: date)
                if let month = components.month, let day = components.day {
                    labelText = String(format: "%02d/%02d", month, day)
                }
            } else {
                let components = dateStr.split(separator: "-")
                labelText = components.count >= 3 ? "\(components[1])/\(components[2])" : dateStr
            }

            let labelString = NSAttributedString(string: labelText, attributes: labelAttributes)
            let labelLine = CTLineCreateWithAttributedString(labelString)
            let labelSize = CTLineGetBoundsWithOptions(labelLine, .useOpticalBounds).size

            // Rotate label for better readability
            context.saveGState()
            let labelX = x + barWidth / 2 + 4
            let labelY = chartArea.origin.y - 20

            context.translateBy(x: labelX, y: labelY)
            context.rotate(by: -CGFloat.pi / 4)

            context.textPosition = CGPoint(x: -labelSize.width / 2, y: 0)
            CTLineDraw(labelLine, context)
            context.restoreGState()
        }
        context.restoreGState()

        // Draw Y-axis labels
        context.saveGState()
        let yLabelAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 9),
            .foregroundColor: NSColor.darkGray
        ]

        let ySteps = 4
        for i in 0...ySteps {
            let value = (maxValue * i) / ySteps
            let y = chartArea.origin.y + (chartArea.height * CGFloat(i)) / CGFloat(ySteps)

            // Draw grid line
            context.setStrokeColor(gray: 0.9, alpha: 1.0)
            context.setLineWidth(0.5)
            context.move(to: CGPoint(x: chartArea.origin.x, y: y))
            context.addLine(to: CGPoint(x: chartArea.origin.x + chartArea.width, y: y))
            context.strokePath()

            // Draw label
            let labelText = "\(value)"
            let labelString = NSAttributedString(string: labelText, attributes: yLabelAttributes)
            let labelLine = CTLineCreateWithAttributedString(labelString)
            let labelSize = CTLineGetBoundsWithOptions(labelLine, .useOpticalBounds).size

            context.textPosition = CGPoint(x: chartArea.origin.x - labelSize.width - 5, y: y - labelSize.height / 2)
            CTLineDraw(labelLine, context)
        }
        context.restoreGState()
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

    private static func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
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
