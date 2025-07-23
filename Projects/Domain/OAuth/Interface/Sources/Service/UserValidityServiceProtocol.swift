//
//  UserValidityServiceInterface.swift
//  DomainOAuthInterface
//
//  Created by Greem on 7/23/25.
//

import Foundation
import CoreLocalStorageInterface

public protocol UserValidityServiceProtocol {
    func isValid() async throws -> Bool
}

public final class UserValidityService {
    public let tokenStorage: TokenStorageProtocol
    public let tokenKeyHolder: TokenKeyHolderProtocol
    
    public init(
        tokenStorage: TokenStorageProtocol,
        tokenKeyHolder: TokenKeyHolderProtocol
    ) {
        self.tokenStorage = tokenStorage
        self.tokenKeyHolder = tokenKeyHolder
    }
}
