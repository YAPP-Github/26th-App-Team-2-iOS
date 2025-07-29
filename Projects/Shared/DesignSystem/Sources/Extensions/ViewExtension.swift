//
//  ViewExtension.swift
//  SharedDesignSystem
//
//  Created by Derrick kim on 7/28/25.
//

import SwiftUI

public extension View {
    @ViewBuilder
    func alert<Content: View, Background: View> (
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder background: @escaping () -> Background
    ) -> some View {
        self.modifier(
            BrakeAlertModifier(
                isPresented: isPresented,
                alertContent: content,
                background: background
            )
        )
    }

    @ViewBuilder
    func brakePopUp(
        isPresented: Binding<Bool>,
        title: String,
        message: String? = nil,
        icon: Image? = nil,
        alertType: BrakeAlertView.AlertType = .singleButton,
        primaryButtonTitle: String,
        secondaryButtonTitle: String? = nil,
        primaryAction: @escaping () -> Void,
        secondaryAction: (() -> Void)? = nil,
        showCloseButton: Bool = false,
        closeAction: (() -> Void)? = nil
    ) -> some View {
        self.modifier(
            BrakePopUpModifier(
                isPresented: isPresented,
                title: title,
                message: message,
                icon: icon,
                alertType: alertType,
                primaryButtonTitle: primaryButtonTitle,
                secondaryButtonTitle: secondaryButtonTitle,
                primaryAction: primaryAction,
                secondaryAction: secondaryAction,
                showCloseButton: showCloseButton,
                closeAction: closeAction
            )
        )
    }
}
