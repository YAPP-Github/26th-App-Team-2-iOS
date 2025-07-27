//
//  BrakeNavigationView.swift
//  SharedDesignSystem
//
//  Created by Derrick kim on 7/27/25.
//

import SwiftUI

public struct BrakeNavigationView: View {
    
    private let title: String
    private let onBackButtonTapped: () -> Void
    private let onCloseButtonTapped: () -> Void

    public init(
        title: String,
        onBackButtonTapped: @escaping () -> Void,
        onCloseButtonTapped: @escaping () -> Void
    ) {
        self.title = title
        self.onBackButtonTapped = onBackButtonTapped
        self.onCloseButtonTapped = onCloseButtonTapped
    }
    
    public var body: some View {
        HStack {
            Button {
                onBackButtonTapped()
            } label: {
                Images.iconBack.swiftUIImage
                    .foregroundStyle(Colors.grey300.swiftUIColor)
                    .frame(width: 32, height: 32)
                    .background(Colors.grey800.swiftUIColor)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            
            Spacer()

            Text(title)
                .font(.pretendard(size: 18, type: .semiBold))
                .foregroundStyle(Colors.white.swiftUIColor)
            
            Spacer()

            Button {
                onCloseButtonTapped()
            } label: {
                Images.iconCancel.swiftUIImage
                    .foregroundStyle(Colors.grey300.swiftUIColor)
                    .frame(width: 32, height: 32)
                    .background(Colors.grey800.swiftUIColor)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .frame(width: 357, height: 56)
        .background(Colors.grey900.swiftUIColor)
    }
}
