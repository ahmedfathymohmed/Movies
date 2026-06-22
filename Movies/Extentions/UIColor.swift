//
//  UIColor.swift
//  Movies
//
//  Created by Ahmed Fathy on 21/04/2026.
//

import Foundation
import UIKit

extension UIColor {
   
        static let appBackground = UIColor(
            red: 36/255,
            green: 42/255,
            blue: 50/255,
            alpha: 1
        )
    }
extension UIColor {
    
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex)
        
        if hex.hasPrefix("#") {
            scanner.currentIndex = hex.index(after: hex.startIndex)
        }
        
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255
        let g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255
        let b = CGFloat(rgbValue & 0x0000FF) / 255
        
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
}
