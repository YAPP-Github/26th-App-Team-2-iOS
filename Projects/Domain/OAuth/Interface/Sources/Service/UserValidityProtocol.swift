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
    public let networkProviderProtocol: NetworkProviderProtocol
    
    
    static public func make() -> UserValidityService {
        UserValidityService(
            tokenStorage: KeyChainTokenStorage(),
            tokenKeyHolder: BundleTokenKeyHolder(),
            networkProviderProtocol: NetworkProvider(
                networkSession: NetworkSession(
                    requestInterceptor: TokenInterceptor(
                        tokenStorage: KeyChainTokenStorage(),
                        tokenKeyHolder: BundleTokenKeyHolder()
                    )
                ),
                urlComponentConfig: .default
            )
        )
    }
    
    public init(
        tokenStorage: TokenStorageProtocol,
        tokenKeyHolder: TokenKeyHolderProtocol,
        networkProviderProtocol: NetworkProviderProtocol
    ) {
        self.tokenStorage = tokenStorage
        self.tokenKeyHolder = tokenKeyHolder
        self.networkProviderProtocol = networkProviderProtocol
    }
}
