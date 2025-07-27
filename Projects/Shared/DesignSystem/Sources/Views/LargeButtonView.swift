//
//  LargeButtonView.swift
//  SharedDesignSystem
//
//  Created by Derrick kim on 7/27/25.
//

import SwiftUI

public struct LargeButtonView: View {

    public let title: String
    public let isActive: Bool
    public let height: CGFloat
    public let action: () -> Void

    public init(
        title: String,
        isActive: Bool,
        height: CGFloat = 56,
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
                    .font(.pretendard(size: 16, type: .bold))
                    .foregroundStyle(Colors.grey900.swiftUIColor)
                Spacer()
            }
            .frame(height: height)
            .frame(maxWidth: 343)
            .background(isActive ? Colors.white.swiftUIColor : Colors.grey700.swiftUIColor)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
        .interactiveDismissDisabled(true)
    }
    
}
