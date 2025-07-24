//
//  MemberStateProtocol.swift
//  DomainOAuthInterface
//
//  Created by Greem on 7/24/25.
//

import Foundation
import Core

public protocol OnboardingStateProtocol {
    func getMemeberState() -> MemberStateType
    func setMembserState(_ memberState: MemberStateType)
}

public final class OnboardingStateService {
    
    public let memberStateStorage: MemberStateStorageProtocol
    
    public static func make() -> OnboardingStateService {
        OnboardingStateService(memberStateStorage: UserDefaultsMemberStateStorage())
    }
    
    init(memberStateStorage: MemberStateStorageProtocol) {
        self.memberStateStorage = memberStateStorage
    }
}
