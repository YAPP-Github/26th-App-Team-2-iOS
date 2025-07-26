//
//  AuthLogInResponse.swift
//  CoreNetworkInterface
//
//  Created by Greem on 7/23/25.
//

import Foundation

public struct AuthLogInResponse: Decodable {
    public let memberState: String
    public let accessToken: String
    public let refreshToken: String
}
