//
//  SmallButtonView.swift
//  SharedDesignSystem
//
//  Created by Derrick kim on 7/27/25.
//

import SwiftUI

public struct SmallButtonView: View {

    private let title: String
    private let isActive: Bool
    private let height: CGFloat
    private let action: () -> Void

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
                    .foregroundStyle(isActive ? Color.grey900 : Color.grey200)
                Spacer()
            }
            .frame(minHeight: 48, maxHeight: height)
            .frame(maxWidth: 160)
            .background(isActive ? Color.brakeWhite : .clear)
            .clipShape(RoundedRectangle(cornerRadius: 100))
        }
        .buttonStyle(.plain)
        .interactiveDismissDisabled(true)
    }

}

