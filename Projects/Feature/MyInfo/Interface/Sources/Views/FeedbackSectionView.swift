//
//  FeedbackSectionView.swift
//  FeatureMyInfo
//
//  Created by Derrick kim on 8/2/25.
//

import SwiftUI
import Combine
import SharedDesignSystem
import SharedUtil

public struct FeedbackSectionView: View {
    private let feedbackSubject: PassthroughSubject<SettingAction, Never>

    public init(
        feedbackSubject: PassthroughSubject<SettingAction, Never>
    ) {
        self.feedbackSubject = feedbackSubject
    }

    public var body: some View {
        VStack(spacing: 0) {
            menuItem(title: ExternalLink.feedback.title, showChevron: true) {
                feedbackSubject.send(.feedback)
            }
            
            Divider()
                .frame(height: 2)
                .background(Color.grey800)
            
            menuItem(title: ExternalLink.contactUs.title, showChevron: true) {
                feedbackSubject.send(.contact)
            }
        }
        .background(Color.grey850)
        .cornerRadius(16)
    }
    
    private func menuItem(title: String, showChevron: Bool, action: @escaping () -> Void) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.grey300)
                .font(.pretendard(size: 16, type: .medium))

            Spacer()
            
            if showChevron {
                Image.iconTinyArrow
                    .foregroundColor(.grey600)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .contentShape(Rectangle())
        .onTapGesture {
            action()
        }
    }
} 
