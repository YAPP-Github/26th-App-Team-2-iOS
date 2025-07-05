//
//  Fonts.swift
//  SharedDesignSystem
//
//  Created by Derrick kim on 7/5/25.
//

import UIKit

public extension UIFont {
    static func pretendard(size fontSize: CGFloat, type: PretendardFontType) -> UIFont {
        return UIFont(name: "\(type.name)", size: fontSize) ?? .init()
    }
}

public extension UIFont {
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
