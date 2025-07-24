//
//  KakaoLogInService.swift
//  DomainOAuthInterface
//
//  Created by Greem on 7/23/25.
//

import Foundation
import Core
import KakaoSDKAuth
import KakaoSDKCommon

public final class KakaoLogInService {
    public let networkProvider: NetworkProviderProtocol
    public let tokenStorage: TokenStorageProtocol
    public let tokenKeyHodler: TokenKeyHolderProtocol
    public let memberStateStorage: MemberStateStorageProtocol
    
    public static func make() -> KakaoLogInService {
        KakaoLogInService(
            networkProvider: NetworkProvider(
                networkSession: NetworkSession(),
                urlComponentConfig: .default
            ),
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
