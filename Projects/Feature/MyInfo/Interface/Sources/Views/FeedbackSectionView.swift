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
        VStack(spacing: 2) {
            MyInfoMainSettingCell(title: ExternalLink.feedback.title, showChevron: true) {
                feedbackSubject.send(.feedback)
            }
            
            
            MyInfoMainSettingCell(title: ExternalLink.contactUs.title, showChevron: true) {
                feedbackSubject.send(.contact)
            }
        }
        
        .cornerRadius(16)
    }
}
