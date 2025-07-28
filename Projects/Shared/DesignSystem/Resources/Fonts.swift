//
//  Fonts.swift
//  SharedDesignSystem
//
//  Created by Derrick kim on 7/5/25.
//

import SwiftUI

public extension Font {
    static func pretendard(size fontSize: CGFloat, type: PretendardFontType) -> Font {
        return Font.custom(type.name, size: fontSize)
    }
}

public extension Font {
    enum PretendardFontType {
        case black
        case bold
        case extraBold
        case extraLight
        case light
        case medium
        case semiBold
        case thin

        public var name : String {
            switch self {
            case .black:
                return "Pretendard-Black"
            case .bold:
                return "Pretendard-Bold"
            case .extraBold:
                return "Pretendard-ExtraBold"
            case .extraLight:
                return "Pretendard-ExtraLight"
            case .light:
                return "Pretendard-Light"
            case .medium:
                return "Pretendard-Medium"
            case .semiBold:
                return "Pretendard-SemiBold"
            case .thin:
                return "Pretendard-Thin"
            }
        }
    }
}
