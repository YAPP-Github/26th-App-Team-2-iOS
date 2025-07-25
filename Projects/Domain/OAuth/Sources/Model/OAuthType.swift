//
//  OAuthType.swift
//  DomainOAuth
//
//  Created by Greem on 7/25/25.
//

import Foundation
import DomainOAuthInterface

extension OAuthType {
    public var provider: String {
        switch self {
        case .apple: "APPLE"
        case .kakao: "KAKAO"
        }
    }
}
