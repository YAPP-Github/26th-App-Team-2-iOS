//
//  KeyChainTokenStorageProtocol.swift
//  CoreLocalStorageInterface
//
//  Created by Derrick kim on 7/9/25.
//

import Foundation

public protocol KeyChainTokenStorageProtocol {
    func read<T: TokenType>(key: String) throws -> T?
    func save<T: TokenType>(
        token: T,
        for key: String
    ) throws
    @discardableResult
    func delete(for key: String) throws -> Bool
}
