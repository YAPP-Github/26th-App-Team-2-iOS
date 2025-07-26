//
//  UserStorageProtocol.swift
//  CoreLocalStorageInterface
//
//  Created by Greem on 7/26/25.
//

import Foundation

public protocol UserStorageProtocol {
    func saveNickName(_ nickName: String)
    func getNickName() -> String?
}

public final class UserDefaultsUserStorage {
    public init() { }
    
}

extension UserDefaultsUserStorage: UserStorageProtocol {
    private var NICKNAME: String { "NICKNAME" }
    
    public func saveNickName(_ nickName: String) {
        UserDefaults.standard.set(nickName, forKey: self.NICKNAME)
    }
    
    public func getNickName() -> String? {
        return UserDefaults.standard.string(forKey: self.NICKNAME)
    }
}
