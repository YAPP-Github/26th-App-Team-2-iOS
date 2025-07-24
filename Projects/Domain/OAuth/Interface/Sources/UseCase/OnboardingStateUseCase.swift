//
//  OnboardingStateUseCase.swift
//  DomainOAuthInterface
//
//  Created by Greem on 7/24/25.
//

import Foundation

public struct OnboardingStateUseCase {
    private let onboardingStateProtocol: OnboardingStateProtocol
    
    public init(
        onboardingStateProtocol: OnboardingStateProtocol
    ) {
        self.onboardingStateProtocol = onboardingStateProtocol
    }
    
    public func execute() -> UserLogInStateType {
        switch onboardingStateProtocol.getMemeberState() {
        case .active: return .brakeAvailable
        case .hold: return .onboardingRequired
        }
    }
}
