//
//  BrakeToastView.swift
//  SharedDesignSystem
//
//  Created by Derrick kim on 7/27/25.
//

import SwiftUI

public struct BrakeToastView: View {
    
    private let message: String
    private let backgroundColor: Color
    private let textColor: Color
    
    public init(
        message: String,
        backgroundColor: Color = .grey850,
        textColor: Color = Color.white
    ) {
        self.message = message
        self.backgroundColor = backgroundColor
        self.textColor = textColor
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            // 아이콘
            Image.iconCheckInsightBlue
                .frame(width: 24, height: 24)
                .clipShape(Circle())
            
            // 메시지
            Text(message)
                .font(.pretendard(size: 14, type: .medium))
                .foregroundStyle(textColor)
                .lineLimit(2)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .frame(height: 60)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
