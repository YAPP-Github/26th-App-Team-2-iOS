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
    
    private let userSetNickNameUseCase: UserSetNickNameUseCase
    private let onboardingCompleted: (() -> ())
    private let userName: String
    
    public init(
        userName: String,
        userSetNickNameUseCase: UserSetNickNameUseCase,
        onboardingCompleted: @escaping (() -> ())
    ) {
        self.userName = userName
        self.userSetNickNameUseCase = userSetNickNameUseCase
        self.onboardingCompleted = onboardingCompleted
    }
    
    public func startBtnTapped() {
        print("시작 버튼 탭탭탭!!")
        Task {
            do {
                try await userSetNickNameUseCase.execute(nickname: userName)
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
