//
//  SetNickNameViewModel.swift
//  FeatureOnboardingInterface
//
//  Created by Greem on 7/26/25.
//

import Foundation

@Observable
public final class SetNickNameViewModel {
    public var nickName: String = ""
    public var isValid: Bool = false
    
    @ObservationIgnored
    public var userNickNameCreated: (String) -> ()
    
    public init(userNickNameCreated: @escaping (String) -> ()) {
        self.userNickNameCreated = userNickNameCreated
    }
    
    func validNickName(_ nickName: String) {
        // 10자 초과 시 잘라내기
        var nickName = nickName
        if nickName.count > 10 {
            nickName = String(nickName.prefix(10))
        }
        // 모든 언어의 문자, 숫자만 허용 (공백, 특수문자 불가)
        let regex = "^[\\p{L}\\p{N}]{2,10}$"
        if let _ = nickName.range(of: regex, options: [.regularExpression]) {
            isValid = true
        } else {
            isValid = false
        }
    }
    public func nickNameCompletedBtnTapped() {
        userNickNameCreated(nickName)
    }
}
