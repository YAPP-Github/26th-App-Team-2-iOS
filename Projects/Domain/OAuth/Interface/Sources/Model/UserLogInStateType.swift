//
//  UserLogInStateType.swift
//  DomainOAuthInterface
//
//  Created by Greem on 7/24/25.
//

import Foundation

public enum UserLogInStateType {
    case logInRequired /// 로그인이 요구됨
    case onboardingRequired /// 온보딩이 요구됨
    case brakeAvailable /// 앱을 사용할 수 있음
    case errorOccured(UserLogInStateError)
    
    public enum UserLogInStateError: Equatable {
        case networkDisConnected
    }
}
