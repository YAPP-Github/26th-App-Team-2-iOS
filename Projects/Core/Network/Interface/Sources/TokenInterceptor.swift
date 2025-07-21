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
    public let tokenStorage: KeyChainTokenStorageProtocol
    
    init(tokenStorage: KeyChainTokenStorageProtocol) {
        self.tokenStorage = tokenStorage
    }
}
