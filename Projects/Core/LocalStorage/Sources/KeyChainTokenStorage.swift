//
//  KeyChainTokenStorage.swift
//  CoreLocalStorageInterface
//
//  Created by Derrick kim on 7/9/25.
//

import Foundation
import CoreLocalStorageInterface
import SharedUtil

/// KeyChainTokenStorage를 actor로 바꾸는게 더 타당한 이유
/// 1. save의 경우에 여러 작업에서 동시에 일어날 경우 raceCondition을 보장해준다.
/// 2. KeyChainTokenStorage의 객체 생성은 빈번히 일어나지 않는다.
/// 3. 값 복사를 이용한 사용처가 없다. + 참조 형식에 따른 사이드 이팩트가 발생할 염려가 없다.
/// -> 토큰 인터셉터 객체에서 KeyChainTokenStorage를 내부 저장 프로퍼티 형식으로 사용하는 곳이 유일함
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
}
