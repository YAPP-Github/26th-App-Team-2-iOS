//
//  AppleLogInService.swift
//  DomainOAuth
//
//  Created by Greem on 7/22/25.
//

import Foundation
import CoreNetworkInterface


public final class AppleLogInService: NSObject {
    public let networkProvider: NetworkProviderProtocol
    
    public var identityContinuation: AsyncStream<Result<String, AuthError>>.Continuation?

    public init(
        networkProvider: NetworkProviderProtocol
    ) {
        self.networkProvider = networkProvider
        super.init()
    }
}
