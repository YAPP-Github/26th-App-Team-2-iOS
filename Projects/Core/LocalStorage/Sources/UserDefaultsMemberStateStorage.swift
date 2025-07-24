//
//  UserDefaultsMemberStateStorage.swift
//  CoreLocalStorageInterface
//
//  Created by Greem on 7/23/25.
//

import Foundation
import CoreLocalStorageInterface


extension UserDefaultsMemberStateStorage: @retroactive MemberStateStorageProtocol {
    private var MEMBER_STATE: String { "MEMBER_STATE" }
    public func get() -> MemberStateType? {
        guard let memberStateString: String = UserDefaults.standard.string(forKey: MEMBER_STATE) else {
            return nil
        }
        guard let memberState = MemberStateType(rawValue: memberStateString) else {
            assertionFailure("잘못된 Member state 값")
            return nil
        }
        return memberState
    }
    
    public func save(memberState: MemberStateType) {
        UserDefaults.standard.set(memberState.value, forKey: MEMBER_STATE)
    }
}


fileprivate extension MemberStateType {
    private static let activeRawValue: String = "ACTIVE"
    private static let holdRawValue: String = "HOLD"
    init?(rawValue: String) {
        switch rawValue {
        case Self.activeRawValue: self = .active
        case Self.holdRawValue: self = .hold
        default: return nil
        }
    }
    var value: String {
        switch self {
        case .active: Self.activeRawValue
        case .hold: Self.holdRawValue
        }
    }
}
