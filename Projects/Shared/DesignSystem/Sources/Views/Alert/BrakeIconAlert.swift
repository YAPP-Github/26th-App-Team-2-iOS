//
//  BrakeIconAlert.swift
//  SharedDesignSystem
//
//  Created by Derrick kim on 7/28/25.
//

import SwiftUI

public struct BrakeIconAlert: View {

    private var icon: Image?
    private var title: String
    private var message: String?

    init(icon: Image? = nil, title: String, message: String? = nil) {
        self.icon = icon
        self.title = title
        self.message = message
    }

    public var body: some View {
        if let icon = icon {
            // 아이콘이 있는 경우
            VStack(spacing: 10) {
                icon
                    .foregroundStyle(Color.grey300)

                titleView()
            }
            .padding(.horizontal, 16)
        } else {
            // 아이콘이 없는 경우
            titleView()
        }
    }

    @ViewBuilder
    private func titleView() -> some View {
        if let message = message {
            VStack(spacing: 8) {
                Text(title)
                    .font(.pretendard(size: 22, type: .semiBold))
                    .foregroundStyle(Color.brakeWhite)
                    .multilineTextAlignment(.center)

                Text(message)
                    .font(.pretendard(size: 16, type: .medium))
                    .foregroundStyle(Color.grey300)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            }
            .padding(.horizontal, 16)

            Spacer(minLength: 16)
        } else {
            Spacer(minLength: 17)
            Text(title)
                .font(.pretendard(size: 22, type: .semiBold))
                .foregroundStyle(Color.brakeWhite)
                .multilineTextAlignment(.center)
            Spacer(minLength: 17)
        }
    }
}
