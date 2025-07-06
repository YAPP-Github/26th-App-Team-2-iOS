//
//  KeychainCategory.swift
//  SharedUtil
//
//  Created by Derrick kim on 7/5/25.
//

import Foundation

public enum KeychainCategory: Equatable {
    case accessToken
    case refreshToken
    
    public var key: String? {
        switch self {
        case .accessToken:
            return Bundle.main.accessTokenKey
        case .refreshToken:
            return Bundle.main.refreshTokenKey
        }
    }
}
