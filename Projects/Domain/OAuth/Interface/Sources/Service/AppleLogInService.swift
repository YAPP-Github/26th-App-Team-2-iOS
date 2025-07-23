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
    public var identityContinuation: AsyncStream<Result<String, AuthError>>.Continuation?
    
    public static func make() -> AppleLogInService {
        AppleLogInService (
            networkProvider: NetworkProvider(
                networkSession: NetworkSession(
                    requestInterceptor: TokenInterceptor(
                        tokenStorage: KeyChainTokenStorage(),
                        tokenKeyHolder: BundleTokenKeyHolder()
                    ),
                    urlSession: .shared
                )
            )
        )
    }

    public init(
        networkProvider: NetworkProviderProtocol
    ) {
        self.networkProvider = networkProvider
        super.init()
    }
}
