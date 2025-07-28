//
//  BrakeAlertTwoButtonView.swift
//  SharedDesignSystem
//
//  Created by Derrick kim on 7/28/25.
//

import SwiftUI

public struct BrakeAlertTwoButtonView: View {

    private let primaryButtonTitle: String
    private let secondaryButtonTitle: String
    private let primaryAction: () -> Void
    private let secondaryAction: (() -> Void)?

    public init(
        primaryButtonTitle: String,
        secondaryButtonTitle: String,
        primaryAction: @escaping () -> Void,
        secondaryAction: (() -> Void)? = nil
    ) {
        self.primaryButtonTitle = primaryButtonTitle
        self.secondaryButtonTitle = secondaryButtonTitle
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }

    public var body: some View {
        HStack(spacing: 12) {
            // 취소 버튼
            Button {
                secondaryAction?()
            } label: {
                Text(secondaryButtonTitle)
                    .font(.pretendard(size: 16, type: .semiBold))
                    .foregroundStyle(Color.brakeWhite)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.grey800)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            // 확인 버튼
            Button {
                primaryAction()
            } label: {
                Text(primaryButtonTitle)
                    .font(.pretendard(size: 16, type: .semiBold))
                    .foregroundStyle(Color.grey900)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.brakeWhite)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}
