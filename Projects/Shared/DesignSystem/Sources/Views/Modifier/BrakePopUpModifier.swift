//
//  BrakePopUpModifier.swift
//  SharedDesignSystem
//
//  Created by Derrick kim on 7/28/25.
//

import SwiftUI

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
        primaryBackgroundColor: Color? = nil,
        primaryTextColor: Color? = nil,
        secondaryBackgroundColor: Color? = nil,
        secondaryTextColor: Color? = nil,
        showCloseButton: Bool = false,
        primaryAction: @escaping () -> Void,
        secondaryAction: (() -> Void)? = nil,
        closeAction: (() -> Void)? = nil
    ) {
        self._isPresented = isPresented
        self.alertView = BrakeAlertView(
            title: title,
            message: message,
            icon: icon,
            alertType: alertType,
            primaryButtonTitle: primaryButtonTitle,
            secondaryButtonTitle: secondaryButtonTitle,
            primaryBackgroundColor: primaryBackgroundColor,
            primaryTextColor: primaryTextColor,
            secondaryBackgroundColor: secondaryBackgroundColor,
            secondaryTextColor: secondaryTextColor,
            showCloseButton: showCloseButton,
            primaryAction: primaryAction,
            secondaryAction: secondaryAction,
            closeAction: closeAction
        )
    }

    public func body(content: Content) -> some View {
        content
            .modifier(
                BrakeAlertModifier(
                    isPresented: $isPresented,
                    alertContent: { alertView },
                    background: { Color.black.opacity(0.5) }
                )
            )
    }
}
