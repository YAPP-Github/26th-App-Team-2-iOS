//
//  AuthRefreshRequest.swift
//  CoreNetwork
//
//  Created by Greem on 7/21/25.
//

import Foundation

public struct AuthRefreshRequest: Encodable {
    public let refreshToken: String
    
    public init(refreshToken: String) {
        self.refreshToken = refreshToken
    }
}
