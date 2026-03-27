import Foundation
import UIKit
import SwiftUI

// MARK: - PDF Export Manager
class PDFExportManager {
    
    static func generateDiagnosticPDF(
        vehicleName: String,
        healthScore: Int,
        categories: [HealthCategory],
        journalEntries: [JournalEntry],
        alarms: [MaintenanceAlarm],
        currentMileage: Int
    ) -> Data {
        let pageWidth: CGFloat = 595.0 // A4
        let pageHeight: CGFloat = 842.0
        let margin: CGFloat = 40
        let contentWidth = pageWidth - margin * 2
        
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight))
        
        let data = pdfRenderer.pdfData { context in
            context.beginPage()
            var yOffset: CGFloat = margin
            
            // Header
            let titleFont = UIFont.systemFont(ofSize: 24, weight: .bold)
            let subtitleFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
            let bodyFont = UIFont.systemFont(ofSize: 11, weight: .regular)
            let smallBoldFont = UIFont.systemFont(ofSize: 11, weight: .bold)
            let sectionFont = UIFont.systemFont(ofSize: 16, weight: .bold)
            
            let titleColor = UIColor(red: 0.22, green: 0.74, blue: 0.97, alpha: 1.0)
            let darkColor = UIColor(red: 0.1, green: 0.1, blue: 0.15, alpha: 1.0)
            let grayColor = UIColor(red: 0.5, green: 0.5, blue: 0.55, alpha: 1.0)
            
            // Title
            let title = "AutoDiag Pro - Raport Diagnostic"
            let titleAttrs: [NSAttributedString.Key: Any] = [.font: titleFont, .foregroundColor: titleColor]
            title.draw(at: CGPoint(x: margin, y: yOffset), withAttributes: titleAttrs)
            yOffset += 35
            
            // Date and vehicle
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM yyyy, HH:mm"
            dateFormatter.locale = Locale(identifier: "ro_RO")
            let dateStr = "Data: \(dateFormatter.string(from: Date()))"
            dateStr.draw(at: CGPoint(x: margin, y: yOffset), withAttributes: [.font: bodyFont, .foregroundColor: grayColor])
            yOffset += 18
            
            let vehicleStr = "Vehicul: \(vehicleName)"
            vehicleStr.draw(at: CGPoint(x: margin, y: yOffset), withAttributes: [.font: subtitleFont, .foregroundColor: darkColor])
            yOffset += 18
            
            let mileageStr = "Kilometraj: \(currentMileage) km"
            mileageStr.draw(at: CGPoint(x: margin, y: yOffset), withAttributes: [.font: bodyFont, .foregroundColor: grayColor])
            yOffset += 30
            
            // Separator
            drawLine(context: context.cgContext, from: CGPoint(x: margin, y: yOffset), to: CGPoint(x: pageWidth - margin, y: yOffset), color: titleColor.cgColor)
            yOffset += 20
            
            // Health Score
            let scoreSection = "SCOR SANATATE VEHICUL"
            scoreSection.draw(at: CGPoint(x: margin, y: yOffset), withAttributes: [.font: sectionFont, .foregroundColor: darkColor])
            yOffset += 25
            
            let scoreLabel = scoreText(healthScore)
            let scoreStr = "\(healthScore)/100 - \(scoreLabel)"
            let scoreColor = healthScore >= 80 ? UIColor(red: 0.13, green: 0.77, blue: 0.37, alpha: 1.0) : (healthScore >= 50 ? UIColor(red: 0.98, green: 0.75, blue: 0.15, alpha: 1.0) : UIColor(red: 0.94, green: 0.27, blue: 0.27, alpha: 1.0))
            scoreStr.draw(at: CGPoint(x: margin, y: yOffset), withAttributes: [.font: UIFont.systemFont(ofSize: 20, weight: .black), .foregroundColor: scoreColor])
            yOffset += 35
            
            // Categories
            for category in categories {
                let catStr = "\(category.name): \(category.score)/100 - \(category.details)"
                let catColor = category.score >= 80 ? UIColor(red: 0.13, green: 0.77, blue: 0.37, alpha: 1.0) : (category.score >= 50 ? UIColor(red: 0.98, green: 0.75, blue: 0.15, alpha: 1.0) : UIColor(red: 0.94, green: 0.27, blue: 0.27, alpha: 1.0))
                
                "  \u{2022} ".draw(at: CGPoint(x: margin, y: yOffset), withAttributes: [.font: bodyFont, .foregroundColor: catColor])
                catStr.draw(at: CGPoint(x: margin + 15, y: yOffset), withAttributes: [.font: bodyFont, .foregroundColor: darkColor])
                yOffset += 16
                
                for rec in category.recommendations {
                    "    \u{25B8} \(rec)".draw(at: CGPoint(x: margin + 20, y: yOffset), withAttributes: [.font: bodyFont, .foregroundColor: grayColor])
                    yOffset += 14
                }
                yOffset += 4
            }
            
            yOffset += 10
            drawLine(context: context.cgContext, from: CGPoint(x: margin, y: yOffset), to: CGPoint(x: pageWidth - margin, y: yOffset), color: UIColor.lightGray.cgColor)
            yOffset += 15
            
            // Maintenance Alarms
            let alarmsSection = "ALARME INTRETINERE"
            alarmsSection.draw(at: CGPoint(x: margin, y: yOffset), withAttributes: [.font: sectionFont, .foregroundColor: darkColor])
            yOffset += 25
            
            for alarm in alarms.prefix(8) {
                let days = alarm.daysRemaining()
                let km = alarm.kmRemaining(currentMileage: currentMileage)
                let status = days <= 0 || km <= 0 ? "DEPASIT" : (days <= 30 || km <= 2000 ? "CURAND" : "OK")
                let alarmStr = "\(alarm.componentName) - \(status) (\(max(0, days)) zile, \(max(0, km)) km ramasi)"
                
                let alarmColor = days <= 0 || km <= 0 ? UIColor.red : (days <= 30 ? UIColor.orange : UIColor.darkGray)
                alarmStr.draw(at: CGPoint(x: margin + 10, y: yOffset), withAttributes: [.font: bodyFont, .foregroundColor: alarmColor])
                yOffset += 16
                
                if yOffset > pageHeight - 100 {
                    context.beginPage()
                    yOffset = margin
                }
            }
            
            yOffset += 10
            
            // Recent Journal Entries
            if !journalEntries.isEmpty {
                if yOffset > pageHeight - 200 {
                    context.beginPage()
                    yOffset = margin
                }
                
                drawLine(context: context.cgContext, from: CGPoint(x: margin, y: yOffset), to: CGPoint(x: pageWidth - margin, y: yOffset), color: UIColor.lightGray.cgColor)
                yOffset += 15
                
                let journalSection = "ULTIMELE INTERVENTII"
                journalSection.draw(at: CGPoint(x: margin, y: yOffset), withAttributes: [.font: sectionFont, .foregroundColor: darkColor])
                yOffset += 25
                
                for entry in journalEntries.prefix(10) {
                    let entryStr = "\(entry.formattedDate) - \(entry.title) (\(entry.formattedCost))"
                    entryStr.draw(at: CGPoint(x: margin + 10, y: yOffset), withAttributes: [.font: bodyFont, .foregroundColor: darkColor])
                    yOffset += 14
                    
                    entry.details.draw(at: CGPoint(x: margin + 20, y: yOffset), withAttributes: [.font: bodyFont, .foregroundColor: grayColor])
                    yOffset += 18
                    
                    if yOffset > pageHeight - 80 {
                        context.beginPage()
                        yOffset = margin
                    }
                }
            }
            
            // Footer
            yOffset = pageHeight - 50
            let footer = "Generat cu AutoDiag Pro Ultimate - \(dateFormatter.string(from: Date()))"
            let footerAttrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 9), .foregroundColor: grayColor]
            let footerSize = (footer as NSString).size(withAttributes: footerAttrs)
            footer.draw(at: CGPoint(x: (pageWidth - footerSize.width) / 2, y: yOffset), withAttributes: footerAttrs)
        }
        
        return data
    }
    
    private static func drawLine(context: CGContext, from: CGPoint, to: CGPoint, color: CGColor) {
        context.setStrokeColor(color)
        context.setLineWidth(0.5)
        context.move(to: from)
        context.addLine(to: to)
        context.strokePath()
    }
    
    private static func scoreText(_ score: Int) -> String {
        if score >= 90 { return "Excelent" }
        if score >= 80 { return "Foarte Bun" }
        if score >= 70 { return "Bun" }
        if score >= 50 { return "Acceptabil" }
        if score >= 30 { return "Necesita Atentie" }
        return "Critic"
    }
}
