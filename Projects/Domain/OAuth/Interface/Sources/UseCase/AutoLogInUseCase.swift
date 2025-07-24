//
//  AutoLogInUseCase.swift
//  DomainOAuthInterface
//
//  Created by Greem on 7/23/25.
//

import Foundation

public struct AutoLogInUseCase {
    
    private let userValidityProtocol: UserValidityProtocol
    private let onboardingStateProtocol: OnboardingStateProtocol
    
    public init(
        userValidityProtocol: UserValidityProtocol,
        onboardingStateProtocol: OnboardingStateProtocol
    ) {
        self.userValidityProtocol = userValidityProtocol
        self.onboardingStateProtocol = onboardingStateProtocol
    }
    
    public func execute() async -> UserLogInStateType {
        do {
            let isUserValid = try await userValidityProtocol.isValid()
            guard isUserValid else {
                return .logInRequired
            }
            switch onboardingStateProtocol.getMemeberState() {
            case .active: return .brakeAvailable
            case .hold: return .onboardingRequired
            }
        } catch {
            return .logInRequired
        }
    }
}
