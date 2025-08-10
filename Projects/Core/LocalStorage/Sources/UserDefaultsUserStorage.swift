//
//  UserDefaultsUserStorage.swift
//  CoreLocalStorage
//
//  Created by Greem on 8/9/25.
//

import Foundation
import CoreLocalStorageInterface

extension UserDefaultsUserStorage: @retroactive UserStorageProtocol {
    private var NICKNAME: String { "NICKNAME" }
    
    public func saveNickname(_ nickname: String) {
        UserDefaults.standard.set(nickname, forKey: self.NICKNAME)
    }
    
    public func getNickname() -> String? {
        return UserDefaults.standard.string(forKey: self.NICKNAME)
    }
    
    public func deleteNickname() {
        UserDefaults.standard.removeObject(forKey: self.NICKNAME)
    }
}
