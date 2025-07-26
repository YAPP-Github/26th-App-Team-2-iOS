//
//  StartUpViewModel.swift
//  FeatureOnboardingInterface
//
//  Created by Greem on 7/24/25.
//

import Foundation
import Domain



@Observable
public class StartUpViewModel {
    public var userLogInState: UserLogInStateType = .unknown
    
    private let autoLogInUseCase: AutoLogInUseCase
    private let onboardingStateUseCase: OnboardingStateUseCase
    
    @ObservationIgnored
    private var isCompleted: Bool = false
    
    public init() {
        self.autoLogInUseCase = AutoLogInUseCase(
            userValidity: UserValidityService.make(),
            onboardingState: OnboardingStateService.make()
        )
        self.onboardingStateUseCase = OnboardingStateUseCase(onboardingState: OnboardingStateService.make())
    }
    
    public func startUpOnAppear() {
        if isCompleted { return }
        isCompleted = true
        Task {
            let autoLogInResult: UserLogInStateType = await autoLogInUseCase.execute()
            await MainActor.run { [weak self] in
                guard let self else { return }
                self.userLogInState = autoLogInResult
            }
        }
    }
    public func logInCompleted() {
        Task { @MainActor in
            let result: UserLogInStateType = onboardingStateUseCase.execute()
            self.userLogInState = result
        }
    }
    public func onboardingCompleted() {
        self.userLogInState = .brakeAvailable
    }
}
