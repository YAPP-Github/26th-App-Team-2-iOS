 
//
//  UserSetNicknameUseCase.swift
//  DomainUser
//
//  Created by Greem on 7/26/25.
//

import Foundation
import Core

public struct UserSetNicknameUseCase {
    
    private let userProfileService: UserProfileProtocol
    
    public init(
        userProfileService: UserProfileProtocol
    ) {
        self.userProfileService = userProfileService
    }
    
    public func execute(nickname: String) async throws {
        try await userProfileService.setUserNickname(nickname)
    }
} 
