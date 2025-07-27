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
}

public final class UserDefaultsUserStorage {
    public init() { }
    
}

extension UserDefaultsUserStorage: UserStorageProtocol {
    private var NICKNAME: String { "NICKNAME" }
    
    public func saveNickname(_ nickname: String) {
        UserDefaults.standard.set(nickname, forKey: self.NICKNAME)
    }
    
    public func getNickname() -> String? {
        return UserDefaults.standard.string(forKey: self.NICKNAME)
    }
}
