//
//  UserVerifyProtocol.swift
//  DomainOAuthInterface
//
//  Created by Greem on 7/23/25.
//

import Foundation
import CoreNetworkInterface
import CoreLocalStorageInterface

public protocol UserVerifyProtocol {
    var networkProvider: NetworkProviderProtocol { get }
    var tokenStorage: TokenStorageProtocol { get }
    var tokenKeyHolder: TokenKeyHolderProtocol { get }
    var memberStateStorage: MemberStateStorageProtocol { get }
    
    func verify(oAuthType: OAuthType, authorizationCode: String) async throws
}


