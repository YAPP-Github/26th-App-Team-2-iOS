//
//  SetNicknameViewModel.swift
//  FeatureOnboardingInterface
//
//  Created by Greem on 7/26/25.
//

import Foundation

@Observable
public final class SetNicknameViewModel {
    public var nickname: String = ""
    public var isValid: Bool = false
    
    @ObservationIgnored
    public var userNicknameCreated: (String) -> ()
    
    public init(userNicknameCreated: @escaping (String) -> ()) {
        self.userNicknameCreated = userNicknameCreated
    }
    
    func validNickname(_ nickname: String) {
        // 10자 초과 시 잘라내기
        var nickname = nickname
        if nickname.count > 10 {
            nickname = String(nickname.prefix(10))
        }
        // 모든 언어의 문자, 숫자만 허용 (공백, 특수문자 불가)
        let regex = "^[\\p{L}\\p{N}]{2,10}$"
        if let _ = nickname.range(of: regex, options: [.regularExpression]),
           nickname.count < 10 {
            isValid = true
        } else {
            isValid = false
        }
    }
    public func nicknameCompletedBtnTapped() {
        userNicknameCreated(nickname)
    }
}
