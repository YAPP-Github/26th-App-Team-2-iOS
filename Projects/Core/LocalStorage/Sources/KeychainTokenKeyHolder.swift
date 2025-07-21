//
//  KeychainTokenKeyHolder.swift
//  CoreLocalStorage
//
//  Created by Greem on 7/21/25.
//

import CoreLocalStorageInterface
import SharedUtil
import Foundation

extension KeychainTokenKeyHolder: TokenKeyHolderProtocol {
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
