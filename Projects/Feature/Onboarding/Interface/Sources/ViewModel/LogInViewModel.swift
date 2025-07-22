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
    
    public init(appleLogInUseCase: OAuthLogInUseCase) {
        self.appleLogInUseCase = appleLogInUseCase
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
        
    }
}
