//
//  Colors.swift
//  SharedDesignSystem
//
//  Created by Derrick kim on 7/27/25.
//

import Foundation
import SwiftUI

public extension Color {
    static let brakeYellowDark: Color = SharedDesignSystemAsset.Colors.brakeYellowDark.swiftUIColor
    static let brakeYellow = SharedDesignSystemAsset.Colors.brakeYellow.swiftUIColor
    static let buttonYellow = SharedDesignSystemAsset.Colors.buttonYellow.swiftUIColor
    static let error: Color = SharedDesignSystemAsset.Colors.error.swiftUIColor
    static let grey100: Color = SharedDesignSystemAsset.Colors.grey100.swiftUIColor
    static let grey200: Color = SharedDesignSystemAsset.Colors.grey200.swiftUIColor
    static let grey300: Color = SharedDesignSystemAsset.Colors.grey300.swiftUIColor
    static let grey400: Color = SharedDesignSystemAsset.Colors.grey400.swiftUIColor
    static let grey50: Color = SharedDesignSystemAsset.Colors.grey50.swiftUIColor
    static let grey500: Color = SharedDesignSystemAsset.Colors.grey500.swiftUIColor
    static let grey600: Color = SharedDesignSystemAsset.Colors.grey600.swiftUIColor
    static let grey700: Color = SharedDesignSystemAsset.Colors.grey700.swiftUIColor
    static let grey800: Color = SharedDesignSystemAsset.Colors.grey800.swiftUIColor
    static let grey850: Color = SharedDesignSystemAsset.Colors.grey850.swiftUIColor
    static let grey900: Color = SharedDesignSystemAsset.Colors.grey900.swiftUIColor
    static let guideGreen: Color = SharedDesignSystemAsset.Colors.guideGreen.swiftUIColor
    static let guideGreenDark: Color = SharedDesignSystemAsset.Colors.guideGreenDark.swiftUIColor
    static let insightBlue: Color = SharedDesignSystemAsset.Colors.insightBlue.swiftUIColor
    static let insightBlueDark: Color = SharedDesignSystemAsset.Colors.insightBlueDark.swiftUIColor
    static let insightBlueLight: Color = SharedDesignSystemAsset.Colors.insightBlueLight.swiftUIColor
    static let brakeWhite: Color = SharedDesignSystemAsset.Colors.white.swiftUIColor
    static let brakeDark: Color = SharedDesignSystemAsset.Colors.brakeDark.swiftUIColor
    static let grey00: Color = SharedDesignSystemAsset.Colors.grey00.swiftUIColor
}


public extension Color {
    public init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit), like "F0A"
            (a, r, g, b) = (255,
                            (int >> 8) * 17,
                            (int >> 4 & 0xF) * 17,
                            (int & 0xF) * 17)
        case 6: // RRGGBB (24-bit), like "FF00AA"
            (a, r, g, b) = (255,
                            int >> 16,
                            int >> 8 & 0xFF,
                            int & 0xFF)
        case 8: // AARRGGBB (32-bit), like "CCFF00AA"
            (a, r, g, b) = (int >> 24,
                            int >> 16 & 0xFF,
                            int >> 8 & 0xFF,
                            int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0) // 잘못된 값일 때 검은색
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}