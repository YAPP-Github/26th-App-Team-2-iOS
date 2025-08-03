//
//  SetNicknameViewModel.swift
//  FeatureOnboardingInterface
//
//  Created by Greem on 7/26/25.
//

import Foundation
import Domain

@Observable
public final class SetNicknameViewModel {
    public var nickname: String = ""
    public var isValid: Bool = false
    public var resetLogInPresent: Bool = false
    
    
    @ObservationIgnored public let userNicknameCreated: (String) -> ()
    
    @ObservationIgnored public let logInCancelCompleted: () -> ()
    
    private let logInCancelUseCase: LogInCancelUseCase
    
    public init(
        logInCancelUseCase: LogInCancelUseCase,
        logInCancelCompleted: @escaping () -> (),
        userNicknameCreated: @escaping (String) -> ()
    ) {
        
        self.logInCancelUseCase = logInCancelUseCase
        self.logInCancelCompleted = logInCancelCompleted
        self.userNicknameCreated = userNicknameCreated
    }
    
    func validNickname(_ nickname: String) {
        // 10자 초과 시 잘라내기
        var nickname = nickname
        if nickname.count > 10 {
            nickname = String(nickname.prefix(10))
        }
        self.nickname = nickname
        // 모든 언어의 문자, 숫자만 허용 (공백, 특수문자 불가)
        isValid = nickname.isValidNickName
    }
    public func nicknameCompletedBtnTapped() {
        userNicknameCreated(nickname)
    }
    
    public func backButtonTapped() {
        resetLogInPresent = true
    }
    public func confirmDeleteUserButtonTapped() {
        Task {
            do {
                try await logInCancelUseCase.execute()
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    logInCancelCompleted()
                }
            } catch {
#if DEBUG
                print("로그아웃 유즈케이스 실패: \(error)")
#endif
            }
        }
    }
}
