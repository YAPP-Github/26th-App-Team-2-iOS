//
//  ActiveUserUseCase.swift
//  DomainUserInterface
//
//  Created by Greem on 8/28/25.
//

import Foundation
import Core

public struct ActiveUserUseCase {
    private let onboardingState: OnboardingStateProtocol
    
    public init(onboardingState: OnboardingStateProtocol) {
        self.onboardingState = onboardingState
    }
    
    public func execute() {
        onboardingState.setMemberState(.active)
    }
}
