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
}
