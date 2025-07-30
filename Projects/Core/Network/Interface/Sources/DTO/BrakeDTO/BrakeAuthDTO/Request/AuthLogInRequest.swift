//
//  AuthLogInRequest.swift
//  CoreNetworkInterface
//
//  Created by Greem on 7/23/25.
//

import Foundation

public struct AuthLogInRequest: Encodable {
    public let provider: String
    public let authorizationCode: String
    public let deviceName: String
    
    public init(
        provider: String,
        authorizationCode: String,
        deviceName: String
    ) {
        self.provider = provider
        self.authorizationCode = authorizationCode
        self.deviceName = deviceName
    }
}
