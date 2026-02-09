//
//  Colorextension.swift
//  9T2
//
//  Created by Jumana on 20/08/1447 AH.
//
import SwiftUI

// 🎨 Extension للألوان - ملف واحد تستخدميه في كل مكان
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        self.init(
            red: Double((int >> 16) & 0xFF) / 255,
            green: Double((int >> 8) & 0xFF) / 255,
            blue: Double(int & 0xFF) / 255
        )
    }
}
