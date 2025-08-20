//
//  FakeTokenStorage.swift
//  CoreNetworkTests
//
//  Created by Greem on 7/21/25.
//

import Foundation
import CoreLocalStorageInterface

public class FakeTokenStorage: TokenStorageProtocol {
    
    
    public static let fakeAccessToken = "fakeAccessToken"
    public static let fakeRefreshToken = "fakeRefreshToken"
    private var storage: [String: Any] = [:]

    public init() { }

    public func read<T: TokenType>(key: String) throws -> T? {
        return storage[key] as? T
    }

    public func save<T: TokenType>(token: T, for key: String) throws {
        storage[key] = token
    }

    @discardableResult
    public func delete(for key: String) throws -> Bool {
        return storage.removeValue(forKey: key) != nil
    }
    
    public func deleteAllTokens() async throws {
        
    }
}
