//
//  MyInfoMainSettingCell.swift
//  FeatureMyInfo
//
//  Created by Greem on 8/9/25.
//

import SwiftUI
import SharedDesignSystem

public struct MyInfoMainSettingCell: View {
    private let title: String
    private let showChevron: Bool
    private let subtitle: String?
    private let action: (() -> ())?
    
    public init(title: String, showChevron: Bool, action: @escaping () -> Void) {
        self.title = title
        self.showChevron = showChevron
        self.action = action
        self.subtitle = nil
    }
    
    public init(title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
        self.showChevron = false
        self.action = nil
    }
    
    public var body: some View {
        Button {
            if let action { action() }
        } label: {
            HStack {
                Text(title)
                    .foregroundColor(.grey300)
                    .font(.pretendard(size: 16, type: .medium))
                
                Spacer()
                HStack(spacing: 2) {
                    if let subtitle {
                        Text(subtitle)
                            .foregroundColor(.grey600)
                            .font(.pretendard(size: 14, type: .regular))
                    }
                    if showChevron {
                        Image.iconTinyArrow
                            .foregroundColor(.grey600)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color.grey850)
        }
        .allowsHitTesting(action != nil)
    }
}
