//
//  BrakeAlertView.swift
//  SharedDesignSystem
//
//  Created by Derrick kim on 7/28/25.
//

import SwiftUI

public struct BrakeAlertView: View {

    private let title: String
    private let message: String?
    private let icon: Image?
    private let primaryButtonTitle: String
    private let secondaryButtonTitle: String?
    private let primaryAction: () -> Void
    private let secondaryAction: (() -> Void)?
    private let alertType: AlertType
    private let showCloseButton: Bool
    private let closeAction: (() -> Void)?

    public enum AlertType {
        case singleButton
        case doubleButton
        case warning
        case success
        case info
    }

    public init(
        title: String,
        message: String? = nil,
        icon: Image? = nil,
        alertType: AlertType = .singleButton,
        primaryButtonTitle: String,
        secondaryButtonTitle: String? = nil,
        primaryAction: @escaping () -> Void,
        secondaryAction: (() -> Void)? = nil,
        showCloseButton: Bool = false,
        closeAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.icon = icon
        self.alertType = alertType
        self.primaryButtonTitle = primaryButtonTitle
        self.secondaryButtonTitle = secondaryButtonTitle
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.showCloseButton = showCloseButton
        self.closeAction = closeAction
    }

    public var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 0) {
                Spacer(minLength: 24)
                // 아이콘 영역
                BrakeIconAlert(
                    icon: icon,
                    title: title,
                    message: message
                )
                Spacer(minLength: 26)

                // 버튼 영역
                VStack(spacing: 12) {
                    if alertType == .doubleButton,
                       let secondaryButtonTitle = secondaryButtonTitle {
                        BrakeAlertTwoButtonView(
                            primaryButtonTitle: primaryButtonTitle,
                            secondaryButtonTitle: secondaryButtonTitle,
                            primaryAction: primaryAction,
                            secondaryAction: secondaryAction
                        )
                    } else {
                        // 단일 버튼
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
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
            .frame(maxWidth: 320, minHeight: 0, maxHeight: 355)
            .fixedSize(horizontal: false, vertical: true)
            .background(Color.grey850)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(
                color: Color.black.opacity(0.25),
                radius: 20,
                x: 0,
                y: 0
            )

            // X 버튼
            if showCloseButton {
                Button {
                    closeAction?()
                } label: {
                    Image.iconCancel
                        .foregroundStyle(Color.grey300)
                        .frame(width: 28, height: 28)
                }
                .padding(.top, 16)
                .padding(.trailing, 16)
            }
        }
    }
}
