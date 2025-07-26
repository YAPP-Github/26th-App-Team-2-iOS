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
    
    let onboardingCompleted: (() -> ())
    private let userOnboardingFinishedUseCase: UserOnboardingFinishedUseCase
    
    public init(
        userOnboardingFinishedUseCase: UserOnboardingFinishedUseCase,
        onboardingCompleted: @escaping (() -> ())
    ) {
        self.userOnboardingFinishedUseCase = userOnboardingFinishedUseCase
        self.onboardingCompleted = onboardingCompleted
    }
    
    public func startBtnTapped() {
        Task {
            await userOnboardingFinishedUseCase.execute(userName: "안녕하세요")
            await MainActor.run { [weak self] in
                guard let self else { return }
                onboardingCompleted()
            }
        }
        
    }
}
