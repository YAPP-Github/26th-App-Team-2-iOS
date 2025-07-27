//
//  MemberStateProtocol.swift
//  DomainOAuthInterface
//
//  Created by Greem on 7/24/25.
//

import Foundation
import Core

public protocol OnboardingStateProtocol {
    func getMemberState() -> MemberStateType
    func setMemberState(_ memberState: MemberStateType)
}

public final class OnboardingStateService {
    
    public let memberStateStorage: MemberStateStorageProtocol
    
    public init(memberStateStorage: MemberStateStorageProtocol) {
        self.memberStateStorage = memberStateStorage
    }
}
