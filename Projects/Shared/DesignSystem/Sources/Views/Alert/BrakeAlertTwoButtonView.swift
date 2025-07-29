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
    
    // 버튼 색상들
    private let primaryBackgroundColor: Color
    private let primaryTextColor: Color
    private let secondaryBackgroundColor: Color
    private let secondaryTextColor: Color

    public init(
        primaryButtonTitle: String,
        secondaryButtonTitle: String,
        primaryAction: @escaping () -> Void,
        secondaryAction: (() -> Void)? = nil,
        primaryBackgroundColor: Color = .brakeWhite,
        primaryTextColor: Color = .grey900,
        secondaryBackgroundColor: Color = .grey800,
        secondaryTextColor: Color = .brakeWhite
    ) {
        self.primaryButtonTitle = primaryButtonTitle
        self.secondaryButtonTitle = secondaryButtonTitle
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.primaryBackgroundColor = primaryBackgroundColor
        self.primaryTextColor = primaryTextColor
        self.secondaryBackgroundColor = secondaryBackgroundColor
        self.secondaryTextColor = secondaryTextColor
    }

    public var body: some View {
        HStack(spacing: 12) {
            // 취소 버튼
            Button {
                secondaryAction?()
            } label: {
                Text(secondaryButtonTitle)
                    .font(.pretendard(size: 16, type: .semiBold))
                    .foregroundStyle(secondaryTextColor)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(secondaryBackgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            // 확인 버튼
            Button {
                primaryAction()
            } label: {
                Text(primaryButtonTitle)
                    .font(.pretendard(size: 16, type: .semiBold))
                    .foregroundStyle(primaryTextColor)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(primaryBackgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}