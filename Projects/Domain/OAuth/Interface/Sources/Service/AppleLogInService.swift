//
//  AppleLogInService.swift
//  DomainOAuth
//
//  Created by Greem on 7/22/25.
//

import Foundation
import CoreLocalStorageInterface
import CoreNetworkInterface


public final class AppleLogInService: NSObject {
    public let networkProvider: NetworkProviderable
    public let tokenStorage: KeyChainTokenStorageProtocol
    
    public var identityContinuation: AsyncStream<Result<String, Error>>.Continuation?

    public init(
        networkProvider: NetworkProviderable,
        tokenStorage: KeyChainTokenStorageProtocol
    ) {
        self.networkProvider = networkProvider
        self.tokenStorage = tokenStorage
        super.init()
    }
}
