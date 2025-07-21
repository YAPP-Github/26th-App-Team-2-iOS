//
//  AuthRefreshDTO.swift
//  CoreNetwork
//
//  Created by Greem on 7/21/25.
//

import Foundation

public struct AuthRefreshResponse: Decodable {
    public let accessToken: String
    public let refreshToken: String
    
    public init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}

