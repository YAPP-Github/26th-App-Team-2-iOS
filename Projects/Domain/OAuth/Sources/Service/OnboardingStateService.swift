//
//  OnboardingStateService.swift
//  DomainOAuthInterface
//
//  Created by Greem on 7/24/25.
//

import Foundation
import DomainOAuthInterface
import Core

extension OnboardingStateService: OnboardingStateProtocol {
    
    public func getMemeberState() -> MemberStateType {
        self.memberStateStorage.get() ?? .hold
    }
    
    public func setMembserState(_ memberState: MemberStateType) {
        self.memberStateStorage.save(memberState: memberState)
    }
}
