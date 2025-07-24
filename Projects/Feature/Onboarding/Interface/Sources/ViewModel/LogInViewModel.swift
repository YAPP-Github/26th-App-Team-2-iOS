//
//  LogInViewModel.swift
//  FeatureOnboarding
//
//  Created by Greem on 7/22/25.
//

import Foundation
import DomainOAuthInterface

@Observable
public final class LogInViewModel {
    
    var kakaoLogInShow: Bool = false
    var loading: Bool = false 
    
    private let appleLogInUseCase: AppleLogInUseCase
    private let kakaoLogInUseCase: KakaoLogInUseCase
    private let logInCompleted: () -> ()
    
    public init(
        appleLogInUseCase: AppleLogInUseCase,
        kakaoLogInUseCase: KakaoLogInUseCase,
        logInCompleted: @escaping () ->()
    ) {
        self.appleLogInUseCase = appleLogInUseCase
        self.kakaoLogInUseCase = kakaoLogInUseCase
        self.logInCompleted = logInCompleted
    }
    
    @MainActor
    func appleLogInBtnTapped() {
        self.loading = true
        Task {
            do {
                try await self.appleLogInUseCase.execute()
                await MainActor.run {
                    self.loading = false
                    logInCompleted()
                }
            } catch {
                await MainActor.run { self.loading = false }
            }
        }
    }
    
    @MainActor
    func kakaoLogInBtnTapped() {
        self.kakaoLogInShow.toggle()
    }
    
    @MainActor
    func kakaoCodeFetchSuccess(authorizationCode: String) {
        self.loading = true
        Task {
            do {
                try await self.kakaoLogInUseCase.execute(authorizationCode: authorizationCode)
                await MainActor.run {
                    self.loading = false
                    logInCompleted()
                }
            } catch {
                await MainActor.run {
                    self.loading = false
                }
            }
        }
    }
    
    func kakaoLogInFailed() {
    }
}
