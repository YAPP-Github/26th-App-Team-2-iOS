//
//  AccountSection.swift
//  FeatureMyInfo
//
//  Created by Derrick kim on 8/2/25.
//

import Foundation

public enum AccountSection: CaseIterable {
    case logout
    case withdraw

    public var title: String {
        switch self {
        case .logout:
            return "로그아웃"
        case .withdraw:
            return "회원탈퇴"
        }
    }
} 
