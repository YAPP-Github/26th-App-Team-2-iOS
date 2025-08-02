//
//  LegalSection.swift
//  FeatureMyInfo
//
//  Created by Derrick kim on 8/2/25.
//

import Foundation

public enum LegalSection: CaseIterable {
    case privacyPolicy
    case termsOfService
    case appVersion
    
    public var title: String {
        switch self {
        case .privacyPolicy:
            return "개인정보 처리방침"
        case .termsOfService:
            return "서비스 약관"
        case .appVersion:
            return "앱 버전 정보"
        }
    }
} 
