//
//  TokenType.swift
//  CoreLocalStorageInterface
//
//  Created by Derrick kim on 7/9/25.
//

import Foundation

// MARK: - TokenType

public protocol TokenType: Codable {
    var token: String { get }
    
    init(token: String)
}

// MARK: - AccessToken

public struct AccessToken: TokenType, Equatable {
    public let token: String
    
    public init(token: String) {
        self.token = token
    }

}

// MARK: - RefreshToken

public struct RefreshToken: TokenType, Equatable {
    public let token: String
    
    public init(token: String) {
        self.token = token

    }
    
    public static func == (lhs: RefreshToken, rhs: RefreshToken) -> Bool {
        lhs.token == rhs.token
    }
}
