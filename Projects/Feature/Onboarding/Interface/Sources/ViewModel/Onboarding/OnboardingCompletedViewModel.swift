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
    
    var errorOccuredPresented: Bool = false
    
    private let userSetNicknameUseCase: UserSetNicknameUseCase
    private let onboardingCompleted: (() -> ())
    private let userName: String
    
    public init(
        userName: String,
        userSetNicknameUseCase: UserSetNicknameUseCase,
        onboardingCompleted: @escaping (() -> ())
    ) {
        self.userName = userName
        self.userSetNicknameUseCase = userSetNicknameUseCase
        self.onboardingCompleted = onboardingCompleted
    }
    
    public func startBtnTapped() {
        Task {
            do {
                try await userSetNicknameUseCase.execute(nickname: userName)
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    onboardingCompleted()
                }
            } catch {
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    self.errorOccuredPresented = true
                }
            }
            
        }
        
    }
}
