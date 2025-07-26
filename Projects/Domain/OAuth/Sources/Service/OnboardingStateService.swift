//
//  OnboardingStateService.swift
//  DomainOAuthInterface
//
//  Created by Greem on 7/24/25.
//

import Foundation
import DomainOAuthInterface
import Core

extension OnboardingStateService: @retroactive OnboardingStateProtocol {
    
    public func getMemberState() -> MemberStateType {
        self.memberStateStorage.get() ?? .hold
    }
    
    public func setMemberState(_ memberState: MemberStateType) {
        self.memberStateStorage.save(memberState: memberState)
    }
}
