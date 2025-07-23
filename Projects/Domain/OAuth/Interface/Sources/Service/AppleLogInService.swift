//
//  AppleLogInService.swift
//  DomainOAuth
//
//  Created by Greem on 7/22/25.
//

import Foundation
import Core

public final class AppleLogInService: NSObject {
    public let networkProvider: NetworkProviderProtocol
    public let tokenStorage: TokenStorageProtocol
    public let tokenKeyHodler: TokenKeyHolderProtocol
    public let memberStateStorage: MemberStateStorageProtocol
    
    public var identityContinuation: AsyncStream<Result<String, AuthError>>.Continuation?
    
    public static func make() -> AppleLogInService {
        AppleLogInService(
            networkProvider: NetworkProvider(networkSession: NetworkSession()),
            tokenStorage: KeyChainTokenStorage(),
            tokenKeyHodler: BundleTokenKeyHolder(),
            memberStateStorage: UserDefaultsMemberStateStorage()
        )
    }

    init(
        networkProvider: NetworkProviderProtocol,
        tokenStorage: TokenStorageProtocol,
        tokenKeyHodler: TokenKeyHolderProtocol,
        memberStateStorage: MemberStateStorageProtocol
    ) {
        self.networkProvider = networkProvider
        self.tokenStorage = tokenStorage
        self.tokenKeyHodler = tokenKeyHodler
        self.memberStateStorage = memberStateStorage
    }
}
