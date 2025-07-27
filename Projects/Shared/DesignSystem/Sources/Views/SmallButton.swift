//
//  SmallButton.swift
//  SharedDesignSystem
//
//  Created by Derrick kim on 7/27/25.
//

import SwiftUI
import SharedDesignSystem

public struct SmallButton: View {
    public let title: String
    public let isActive: Bool
    public let height: CGFloat
    public let action: () -> Void

    public init(
        title: String,
        isActive: Bool,
        height: CGFloat = 48,
        action: @escaping () -> Void
    ) {
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
                    .font(.pretendard(size: 16, type: .semiBold))
                    .foregroundStyle(isActive ? Colors.grey900.swiftUIColor : Colors.grey200.swiftUIColor)
                Spacer()
            }
            .frame(height: height)
            .frame(maxWidth: 160)
            .background(isActive ? Colors.white.swiftUIColor : .clear)
            .clipShape(RoundedRectangle(cornerRadius: 100))
        }
        .buttonStyle(.plain)
        .interactiveDismissDisabled(true)
    }

}

