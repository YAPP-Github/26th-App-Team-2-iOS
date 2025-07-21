//
//  KeyChainTokenStorage.swift
//  CoreLocalStorageInterface
//
//  Created by Derrick kim on 7/9/25.
//

import Foundation
import CoreLocalStorageInterface
import SharedUtil

public struct KeyChainTokenStorage: TokenStorageProtocol {
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

    public func read<T: TokenType>(key: String) throws -> T? {
        guard let data = try keychain.read(key: key) else {
            return nil
        }
        return try JSONDecoder().decode(T.self, from: data)
    }

    public func save<T: TokenType>(
        token: T,
        for key: String
    ) throws {
        let data = try JSONEncoder().encode(token)
        try keychain.save(key: key, data: data)
    }

    @discardableResult
    public func delete(for key: String) throws -> Bool {
        return try keychain.delete(key: key)
    }
}
