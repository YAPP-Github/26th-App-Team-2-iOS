//
//  UserValidityServiceInterface.swift
//  DomainOAuthInterface
//
//  Created by Greem on 7/23/25.
//

import Foundation
import Core

public protocol UserValidityProtocol {
    func isValid() async throws -> Bool
}

public final class UserValidityService {
    public let tokenStorage: TokenStorageProtocol
    public let tokenKeyHolder: TokenKeyHolderProtocol
    public let networkProvider: NetworkProviderProtocol
    
    

    
    public init(
        tokenStorage: TokenStorageProtocol,
        tokenKeyHolder: TokenKeyHolderProtocol,
        networkProviderProtocol: NetworkProviderProtocol
    ) {
        self.tokenStorage = tokenStorage
        self.tokenKeyHolder = tokenKeyHolder
        self.networkProvider = networkProviderProtocol
    }
}
