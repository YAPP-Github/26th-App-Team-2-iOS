//
//  FeedbackSection.swift
//  FeatureMyInfo
//
//  Created by Derrick kim on 8/2/25.
//

import Foundation

public enum FeedbackSection: CaseIterable {
    case feedback
    case contact
    
    public var title: String {
        switch self {
        case .feedback:
            return "의견 남기기"
        case .contact:
            return "문의하기"
        }
    }
} 
