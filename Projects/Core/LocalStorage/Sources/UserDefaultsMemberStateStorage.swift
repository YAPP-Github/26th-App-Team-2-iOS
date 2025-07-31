//
//  UserDefaultsMemberStateStorage.swift
//  CoreLocalStorageInterface
//
//  Created by Greem on 7/23/25.
//

import Foundation
import CoreLocalStorageInterface

extension UserDefaultsMemberStateStorage: @retroactive MemberStateStorageProtocol {
    private enum Keys {
        static let memberState = "MEMBER_STATE"
    }

    public func get() -> MemberStateType? {
        guard let memberStateString: String = UserDefaults.standard.string(forKey: Keys.memberState) else {
            return nil
        }
        guard let memberState = MemberStateType(rawValue: memberStateString) else {
            assertionFailure("잘못된 Member state 값")
            return nil
        }
        return memberState
    }

    public func save(memberState: MemberStateType) {
        UserDefaults.standard.set(memberState.value, forKey: Keys.memberState)
    }
}
