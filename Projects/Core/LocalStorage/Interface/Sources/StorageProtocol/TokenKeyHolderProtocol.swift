//
//  TokenKeyHolder.swift
//  CoreLocalStorage
//
//  Created by Greem on 7/21/25.
//

import Foundation
import SharedUtil

public protocol TokenKeyHolderProtocol {
    func fetchAccessTokenKey() throws -> String
    func fetchRefreshTokenKey() throws -> String
}

public struct KeychainTokenKeyHolder: TokenKeyHolderProtocol {

    public init() { }
    
    public func fetchAccessTokenKey() throws -> String {
        if let accessTokenKey = Bundle.main.accessTokenKey {
            return accessTokenKey
        } else {
            throw TokenKeyHolderError.accessTokenKeyMissing
        }
    }
    
    public func fetchRefreshTokenKey() throws -> String {
        if let refreshTokenKey = Bundle.main.refreshTokenKey {
            return refreshTokenKey
        } else {
            throw TokenKeyHolderError.refreshTokenKeyMissing
        }
    }
}
