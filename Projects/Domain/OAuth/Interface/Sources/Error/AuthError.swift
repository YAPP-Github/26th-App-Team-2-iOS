//
//  AuthError.swift
//  DomainOAuth
//
//  Created by Greem on 7/22/25.
//

import Foundation

public enum AuthError: Error {
    case invalidToken
    case appleOAuthError(AppleOAuthError)
    case validAuthFailed
    case unknownMemberType
}
