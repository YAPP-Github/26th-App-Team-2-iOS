//
//  LargeButtonView.swift
//  SharedDesignSystem
//
//  Created by Derrick kim on 7/27/25.
//

import SwiftUI

public enum ButtonType {
    case `default`
    case confirm
    
    public func backgroundColor(isActive: Bool) -> Color {
        switch self {
        case .default: isActive ? Color.brakeWhite : Color.grey700
        case .confirm: isActive ? Color.brakeYellow : Color.grey700
        }
    }
}

public struct LargeButtonView: View {
    private let buttonType: ButtonType
    private let title: String
    private let isActive: Bool
    private let height: CGFloat
    private let action: () -> Void

    public init(
        buttonType: ButtonType = .default,
        title: String,
        isActive: Bool,
        height: CGFloat = 56,
        action: @escaping () -> Void
    ) {
        self.buttonType = buttonType
        self.title = title
        self.isActive = isActive
        self.height = height
        self.action = action
    }

    public var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Spacer()
                Text(title)
                    .font(.pretendard(size: 16, type: .bold))
                    .foregroundStyle(Color.grey900)
                Spacer()
            }
            .frame(minHeight: 56, maxHeight: height)
            .frame(maxWidth: 343)
            .background(buttonType.backgroundColor(isActive: isActive))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .allowsHitTesting(isActive)
        .buttonStyle(.plain)
        .interactiveDismissDisabled(true)
    }
    
}
