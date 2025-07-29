//
//  Fonts.swift
//  SharedDesignSystem
//
//  Created by Derrick kim on 7/5/25.
//

import SwiftUI

public extension Font {
    static func pretendard(size fontSize: CGFloat, type: PretendardFontType) -> Font {
        return type.fontConvertible.swiftUIFont(size: fontSize)
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

        public var fontConvertible: SharedDesignSystemFontConvertible {
            switch self {
            case .black:
                return SharedDesignSystemFontFamily.Pretendard.black
            case .bold:
                return SharedDesignSystemFontFamily.Pretendard.bold
            case .extraBold:
                return SharedDesignSystemFontFamily.Pretendard.extraBold
            case .extraLight:
                return SharedDesignSystemFontFamily.Pretendard.extraLight
            case .light:
                return SharedDesignSystemFontFamily.Pretendard.light
            case .medium:
                return SharedDesignSystemFontFamily.Pretendard.medium
            case .semiBold:
                return SharedDesignSystemFontFamily.Pretendard.semiBold
            case .thin:
                return SharedDesignSystemFontFamily.Pretendard.thin
            }
        }
    }
}
