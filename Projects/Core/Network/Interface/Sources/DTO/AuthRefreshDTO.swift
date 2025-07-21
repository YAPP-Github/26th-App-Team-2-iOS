//
//  AuthRefreshDTO.swift
//  CoreNetwork
//
//  Created by Greem on 7/21/25.
//

import Foundation


public struct ServerResponseDTO<ResponseItem: Decodable>: Decodable {
    public let code: Int
    public let data: ResponseItem
    
    public init(code: Int, data: ResponseItem) {
        self.code = code
        self.data = data
    }
}

public struct AuthRefreshDTO: Decodable {
    public let accessToken: String
    public let refreshToken: String
    
    public init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}

public struct AuthRefreshTokenDTO: Encodable {
    public let refreshToken: String
    
    public init(refreshToken: String) {
        self.refreshToken = refreshToken
    }
}
