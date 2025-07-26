//
//  OnboardingCompletedViewModel.swift
//  FeatureOnboardingInterface
//
//  Created by Greem on 7/26/25.
//

import Foundation
import Domain

@Observable
public final class OnboardingCompletedViewModel {
    
    private let userOnboardingFinishedUseCase: UserOnboardingFinishedUseCase
    private let onboardingCompleted: (() -> ())
    private let userName: String
    
    public init(
        userName: String,
        userOnboardingFinishedUseCase: UserOnboardingFinishedUseCase,
        onboardingCompleted: @escaping (() -> ())
    ) {
        self.userName = userName
        self.userOnboardingFinishedUseCase = userOnboardingFinishedUseCase
        self.onboardingCompleted = onboardingCompleted
    }
    
    public func startBtnTapped() {
        Task {
            await userOnboardingFinishedUseCase.execute(userName: userName)
            await MainActor.run { [weak self] in
                guard let self else { return }
                onboardingCompleted()
            }
        }
        
    }
}
