//
//  TokenInterceptor.swift
//  CoreNetworkInterface
//
//  Created by Greem on 7/20/25.
//

import Foundation
import CoreLocalStorageInterface
import Shared

final public class TokenInterceptor {
    public let tokenStorage: TokenStorageProtocol
    public let jwtDecoder: JWTDecoder = .init()
    public let tokenKeyHolder: TokenKeyHolderProtocol
    
    init(
        tokenStorage: TokenStorageProtocol,
        tokenKeyHolder: TokenKeyHolderProtocol
    ) {
        self.tokenStorage = tokenStorage
        self.tokenKeyHolder = tokenKeyHolder
    }
    
}
