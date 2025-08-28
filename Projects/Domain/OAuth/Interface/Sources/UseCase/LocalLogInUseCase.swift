//
//  LocalLogInUseCase.swift
//  DomainOAuthInterface
//
//  Created by Greem on 8/28/25.
//

import Foundation
import DomainUserInterface
public struct LocalLogInUseCase {
    
    private let onboardingState: OnboardingStateProtocol
    
    public init(onboardingState: OnboardingStateProtocol) {
        self.onboardingState = onboardingState
    }
    
    public func execute() {
        onboardingState.setMemberState(.hold)
    }
}
