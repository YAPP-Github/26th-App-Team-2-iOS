//
//  OnboardingStateUseCase.swift
//  DomainOAuthInterface
//
//  Created by Greem on 7/24/25.
//

import Foundation

public struct OnboardingStateUseCase {
    private let onboardingState: OnboardingStateProtocol
    
    public init(
        onboardingState: OnboardingStateProtocol
    ) {
        self.onboardingState = onboardingState
    }
    
    public func execute() -> UserLogInStateType {
        switch onboardingState.getMemberState() {
        case .active: return .brakeAvailable
        case .hold: return .onboardingRequired
        }
    }
}
