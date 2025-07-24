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
    public var isLogInCompleted: Bool = false
    public var isOnboardingCompleted: Bool = false
    
    private let autoLogInUseCase: AutoLogInUseCase
    
    @ObservationIgnored private var isCompleted: Bool = false
    
    public init() {
        self.autoLogInUseCase = AutoLogInUseCase(
            userValidityProtocol: UserValidityService.make(),
            onboardingStateProtocol: OnboardingStateService.make()
        )
    }
    
    public func startUpOnAappear() {
        if isCompleted { return }
        Task {
            let autoLogInResult = await autoLogInUseCase.execute()
            print("자동 로그인 결과: ", autoLogInResult)
            await MainActor.run {
                switch autoLogInResult {
                case .logInRequired:
                    self.isLogInCompleted = false
                    self.isOnboardingCompleted = false
                case .onboardingRequired:
                    self.isOnboardingCompleted = false
                    self.isLogInCompleted = true
                case .brakeAvailable:
                    self.isOnboardingCompleted = true
                    self.isLogInCompleted = true
                case .errorOccured(let userLogInStateError):
                    /// Error Alert 띄우는 용도...
                    self.isLogInCompleted = false
                    self.isOnboardingCompleted = false
                }
            }
        }
        isCompleted = true
    }
}
