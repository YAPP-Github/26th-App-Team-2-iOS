//
//  KeyChainTokenStorageProtocol.swift
//  CoreLocalStorageInterface
//
//  Created by Derrick kim on 7/9/25.
//

import Foundation

public protocol TokenStorageProtocol {
    
    func read<T: TokenType>(key: String) async throws -> T?
    
    func save<T: TokenType>(token: T, for key: String) async throws
    
    @discardableResult
    func delete(for key: String) async throws -> Bool
    
    func deleteAllTokens() async throws
}
