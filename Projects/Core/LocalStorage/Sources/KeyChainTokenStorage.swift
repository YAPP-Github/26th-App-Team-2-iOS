//
//  KeyChainTokenStorage.swift
//  CoreLocalStorageInterface
//
//  Created by Derrick kim on 7/9/25.
//

import Foundation
import CoreLocalStorageInterface
import SharedUtil

public actor KeyChainTokenStorage: TokenStorageProtocol {
    public let keychain: Keychain

    public init(keychain: Keychain) {
        self.keychain = keychain
    }

    public init() {
        self.keychain = .init()
    }

    public init(option: Keychain.Option) {
        self.keychain = Keychain(option: option)
    }

    public func read<T: TokenType>(key: String) async throws -> T? {
        guard let data = try keychain.read(key: key) else {
            return nil
        }
        return try JSONDecoder().decode(T.self, from: data)
    }

    public func save<T: TokenType>(
        token: T,
        for key: String
    ) async throws {
        let data = try JSONEncoder().encode(token)
        try keychain.save(key: key, data: data)
    }

    @discardableResult
    public func delete(for key: String) async throws -> Bool {
        return try keychain.delete(key: key)
    }
    
    public func deleteAllTokens() async throws {
        // Keychain에서 모든 토큰 키들을 삭제
        // Bundle에서 실제 키값들을 가져와서 삭제
        let tokenKeyHolder = BundleTokenKeyHolder()
        
        let accessTokenKey = try tokenKeyHolder.fetchAccessTokenKey()
        try keychain.delete(key: accessTokenKey)

        let refreshTokenKey = try tokenKeyHolder.fetchRefreshTokenKey()
        try keychain.delete(key: refreshTokenKey)
    }
}
