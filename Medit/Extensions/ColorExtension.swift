//
//  ColorExtension.swift
//  Medit
//
//  Created by 木本瑛介 on 2023/12/31.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: String) {
        var cleanHexCode: String = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: cleanHexCode).scanHexInt64(&rgb)
        
        let redValue: Double = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue: Double = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue: Double = Double(rgb & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue)
    }
    
    func converttoHex() -> String? {
        let uiColor: UIColor = UIColor(self)
        guard let components = uiColor.cgColor.components, components.count >= 3 else { return nil }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if a != Float(1.0) {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r*255), lroundf(g*255), lroundf(b*255), lroundf(a*255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r*255), lroundf(g*255), lroundf(b*255))
        }
    }
}
