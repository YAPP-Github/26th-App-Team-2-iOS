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
    
    let appleLogInUseCase: OAuthLogInUseCase
    let kakaoLogInUseCase: OAuthLogInUseCase
    
    public init(
        appleLogInUseCase: OAuthLogInUseCase,
        kakaoLogInUseCase: OAuthLogInUseCase
    ) {
        self.appleLogInUseCase = appleLogInUseCase
        self.kakaoLogInUseCase = kakaoLogInUseCase
    }
    
    func appleLogInBtnTapped() {
        
        Task {
            do {
                let type = try await appleLogInUseCase.execute()
                print("타입 반환 \(type)")
            } catch {
                print("에러 발생 \(error)")
            }
        }
        
    }
    
    func kakaoLogInBtnTapped() {
        Task { @MainActor in
            do {
                let type = try await kakaoLogInUseCase.execute()
                print("타입 반환 \(type)")
            } catch {
                print("에러 발생 \(error)")
            }
        }
    }
}
