//
//  OnboardingStateService.swift
//  DomainOAuthInterface
//
//  Created by Greem on 7/24/25.
//

import Foundation
import Core
import DomainUserInterface

extension OnboardingStateService: @retroactive OnboardingStateProtocol {
    
    public func getMemberState() -> MemberStateType {
        self.memberStateStorage.get() ?? .none
    }
    
    public func setMemberState(_ memberState: MemberStateType) {
        self.memberStateStorage.save(memberState: memberState)
    }
}
