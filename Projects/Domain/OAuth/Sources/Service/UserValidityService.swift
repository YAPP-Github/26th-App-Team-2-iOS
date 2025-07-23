//
//  UserValidityService.swift
//  DomainOAuthInterface
//
//  Created by Greem on 7/23/25.
//

import Foundation
import CoreLocalStorageInterface
import DomainOAuthInterface

extension UserValidityService: @retroactive UserValidityServiceProtocol {
    
    public func isValid() async throws -> Bool {
        do {
            let accessTokenKey = try tokenKeyHolder.fetchAccessTokenKey()
            let accessToken: AccessToken? = try await tokenStorage.read(key: accessTokenKey)
            return accessToken != nil
        } catch {
            throw AuthError.validAuthFailed
        }
    }
}
