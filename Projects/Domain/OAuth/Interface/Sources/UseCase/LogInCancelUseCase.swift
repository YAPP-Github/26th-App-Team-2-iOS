//
//  LogInCancelUseCase.swift
//  DomainOAuthInterface
//
//  Created by Greem on 7/31/25.
//

import Foundation
import DomainUserInterface
import DomainSharedInterface


public struct LogInCancelUseCase {
    private let oAuthService: OAuthServiceProtocol
    
    public init(
        oAuthService: OAuthServiceProtocol
        // MARK: -- 앱 그룹 기록 삭제하는 코드도 추가해야한다.
    ) {
        self.oAuthService = oAuthService
    }
    
    public func execute() async throws {
        try await oAuthService.logInCancel()
    }
}
