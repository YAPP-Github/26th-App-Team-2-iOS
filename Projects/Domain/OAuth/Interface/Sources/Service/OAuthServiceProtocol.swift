//
//  OAuthServiceProtocol.swift
//  DomainOAuthInterface
//
//  Created by Greem on 7/22/25.
//

import Foundation
import Core
public protocol OAuthServiceProtocol {
    var networkProvider: NetworkProviderProtocol { get }
    var tokenStorage: TokenStorageProtocol { get }
    var tokenKeyHolder: TokenKeyHolderProtocol { get }
    var memberStateStorage: MemberStateStorageProtocol { get }
    
    func login(oAuthType: OAuthType, authorizationCode: String) async throws
}

public final class OAuthLogInService {
    public let networkProvider: NetworkProviderProtocol
    public let tokenStorage: TokenStorageProtocol
    public let tokenKeyHolder: TokenKeyHolderProtocol
    public let memberStateStorage: MemberStateStorageProtocol
    
    public static func make() -> OAuthLogInService {
        OAuthLogInService(
            networkProvider: NetworkProvider(networkSession: NetworkSession()),
            tokenStorage: KeyChainTokenStorage(),
            tokenKeyHodler: BundleTokenKeyHolder(),
            memberStateStorage: UserDefaultsMemberStateStorage()
        )
    }

    public init(
        networkProvider: NetworkProviderProtocol,
        tokenStorage: TokenStorageProtocol,
        tokenKeyHodler: TokenKeyHolderProtocol,
        memberStateStorage: MemberStateStorageProtocol
    ) {
        self.networkProvider = networkProvider
        self.tokenStorage = tokenStorage
        self.tokenKeyHolder = tokenKeyHodler
        self.memberStateStorage = memberStateStorage
    }
    
}
