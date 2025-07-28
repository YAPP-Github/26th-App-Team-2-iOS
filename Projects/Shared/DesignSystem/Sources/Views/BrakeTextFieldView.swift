//
//  BrakeTextFieldView.swift
//  SharedDesignSystem
//
//  Created by Derrick kim on 7/27/25.
//

import SwiftUI

public struct BrakeTextFieldView: View {
    
    @Binding private var text: String
    private let placeholder: String
    private let backgroundColor: Color
    private let textColor: Color
    private let placeholderColor: Color
    private let cornerRadius: CGFloat
    
    public init(
        text: Binding<String>,
        placeholder: String,
        backgroundColor: Color = Color.grey850,
        textColor: Color = Color.brakeWhite,
        placeholderColor: Color = Color.grey400,
        cornerRadius: CGFloat = 16
    ) {
        self._text = text
        self.placeholder = placeholder
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.placeholderColor = placeholderColor
        self.cornerRadius = cornerRadius
    }
    
    public var body: some View {
        TextField(
            "",
            text: $text,
            prompt: Text(placeholder)
                .foregroundColor(placeholderColor)
        )
        .font(.pretendard(size: 16, type: .medium))
        .tint(textColor)
        .foregroundStyle(textColor)
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}
