//
//  UserStorageProtocol.swift
//  CoreLocalStorageInterface
//
//  Created by Greem on 7/26/25.
//

import Foundation

public protocol UserStorageProtocol {
    func saveNickname(_ nickname: String)
    func getNickname() -> String?
    func deleteNickname()
}

public final class UserDefaultsUserStorage {
    public init() { }
}
