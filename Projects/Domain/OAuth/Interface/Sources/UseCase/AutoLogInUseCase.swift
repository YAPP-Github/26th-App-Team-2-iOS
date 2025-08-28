//
//  AutoLogInUseCase.swift
//  DomainOAuthInterface
//
//  Created by Greem on 7/23/25.
//

import Foundation
import DomainUserInterface

public struct AutoLogInUseCase {
    
    private let userValidity: UserValidityProtocol
    private let onboardingState: OnboardingStateProtocol
    
    public init(
        userValidity: UserValidityProtocol,
        onboardingState: OnboardingStateProtocol
    ) {
        self.userValidity = userValidity
        self.onboardingState = onboardingState
    }
    
    public func execute() async -> UserLogInStateType {
        do {
//            let isUserValid = try await userValidity.isValid()
//            guard isUserValid else { return .logInRequired }
            switch onboardingState.getMemberState() {
            case .active: return .brakeAvailable
            case .hold: return .onboardingRequired
            }
        } catch {
            return .logInRequired
        }
    }
}

