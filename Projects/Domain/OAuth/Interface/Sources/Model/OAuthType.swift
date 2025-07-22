//
//  OAuthType.swift
//  DomainOAuth
//
//  Created by Greem on 7/22/25.
//

import Foundation

public enum OAuthType {
    case apple
    case kakao
}

public enum OAuthResult: Equatable {
    
    case success(OAuthType)
    case failure(AuthError)
}
