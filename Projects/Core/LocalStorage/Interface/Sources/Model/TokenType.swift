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
    var expiration: Date { get }
    
    init(token: String, expiration: Date)
}

// MARK: - AccessToken

public struct AccessToken: TokenType, Equatable {
    public let token: String
    public let expiration: Date
    
    public init(token: String, expiration: Date) {
        self.token = token
        self.expiration = expiration
    }

    public static func == (lhs: AccessToken, rhs: AccessToken) -> Bool {
        lhs.token == rhs.token && lhs.expiration == rhs.expiration
    }
}

// MARK: - RefreshToken

public struct RefreshToken: TokenType, Equatable {
    public let token: String
    public let expiration: Date
    
    public init(token: String, expiration: Date) {
        self.token = token
        self.expiration = expiration
    }
    
    public static func == (lhs: RefreshToken, rhs: RefreshToken) -> Bool {
        lhs.token == rhs.token && lhs.expiration == rhs.expiration
    }
}
