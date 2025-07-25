//
//  LogInViewModel.swift
//  FeatureOnboarding
//
//  Created by Greem on 7/22/25.
//

import Foundation
import DomainOAuthInterface

public protocol LogInViewModelDelegate {
    func logInCompleted()
}


@Observable
public final class LogInViewModel {
    
    var kakaoLogInShow: Bool = false
    var loading: Bool = false 
    
    private let appleLogInUseCase: AppleLogInUseCase
    private let kakaoLogInUseCase: KakaoLogInUseCase
    private let delegate: LogInViewModelDelegate
    
    public init(
        appleLogInUseCase: AppleLogInUseCase,
        kakaoLogInUseCase: KakaoLogInUseCase,
        delegate: LogInViewModelDelegate
    ) {
        self.appleLogInUseCase = appleLogInUseCase
        self.kakaoLogInUseCase = kakaoLogInUseCase
        self.delegate = delegate
    }
    
    @MainActor
    func appleLogInBtnTapped() {
        self.loading = true
        Task {
            do {
                try await self.appleLogInUseCase.execute()
                await MainActor.run {
                    self.loading = false
                    delegate.logInCompleted()
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
                    delegate.logInCompleted()
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
