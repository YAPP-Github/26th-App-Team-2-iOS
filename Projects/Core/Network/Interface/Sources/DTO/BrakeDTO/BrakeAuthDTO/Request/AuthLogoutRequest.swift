//
//  AuthLogoutRequest.swift
//  CoreNetwork
//
//  Created by Assistant on 8/2/25.
//

import Foundation

public struct AuthLogoutRequest: Encodable {
    public let accessToken: String
    
    public init(accessToken: String) {
        self.accessToken = accessToken
    }
} 
