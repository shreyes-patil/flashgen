//
//  AppColors.swift
//  FlashGen
//
//  Created by Shreyas Patil on 7/31/25.
//

import SwiftUI


extension Color {
//    static let cardPalette: [Color] = [
//        Color(hex: "34D399"),
//        Color(hex: "A78BFA"),
//        Color(hex: "FCA5A5"),
//        Color(hex: "1F2937"),
//        Color(hex: "4ADE80")
//    ]
    static let cardPalette: [Color] = [
        Color(hex: "A7F3D0"),  // soft mint
        Color(hex: "DDD6FE"),  // soft lavender
        Color(hex: "FECACA"),  // soft coral/pink
        Color(hex: "FDE68A"),  // soft yellow
        Color(hex: "BFDBFE")   // soft blue
    ]
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.currentIndex = hex.startIndex
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}
