//
//  BrakeAlertView.swift
//  SharedDesignSystem
//
//  Created by Derrick kim on 7/28/25.
//

import SwiftUI

// MARK: - 기본 알림 다이얼로그
public struct BrakeAlertView: View {

    private let title: String
    private let message: String?
    private let icon: Image?
    private let primaryButtonTitle: String
    private let secondaryButtonTitle: String?
    private let primaryAction: () -> Void
    private let secondaryAction: (() -> Void)?
    private let alertType: AlertType

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
        secondaryAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.icon = icon
        self.alertType = alertType
        self.primaryButtonTitle = primaryButtonTitle
        self.secondaryButtonTitle = secondaryButtonTitle
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }

    public var body: some View {
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
                if alertType == .doubleButton, let secondaryButtonTitle = secondaryButtonTitle {
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
    }
}

fileprivate struct BrakeIconAlert: View {
    @State var icon: Image?
    @State var title: String
    @State var message: String?

    var body: some View {
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

// MARK: - ViewModifier
public struct BrakePopUpModifier: ViewModifier {
    @Binding private var isPresented: Bool
    private let alertView: BrakeAlertView
    
    public init(
        isPresented: Binding<Bool>,
        title: String,
        message: String? = nil,
        icon: Image? = nil,
        alertType: BrakeAlertView.AlertType = .singleButton,
        primaryButtonTitle: String,
        secondaryButtonTitle: String? = nil,
        primaryAction: @escaping () -> Void,
        secondaryAction: (() -> Void)? = nil
    ) {
        self._isPresented = isPresented
        self.alertView = BrakeAlertView(
            title: title,
            message: message,
            icon: icon,
            alertType: alertType,
            primaryButtonTitle: primaryButtonTitle,
            secondaryButtonTitle: secondaryButtonTitle,
            primaryAction: primaryAction,
            secondaryAction: secondaryAction
        )
    }
    
    public func body(content: Content) -> some View {
        content
            .modifier(BrakeAlertModifier(
                isPresented: $isPresented,
                alertContent: { alertView },
                background: { Color.black.opacity(0.5) }
            ))
    }
}
