//
//  FetchUserNicknameUseCase.swift
//  DomainUser
//
//  Created by Derrick kim on 8/2/25.
//

import Core
import DomainUserInterface

public struct FetchUserNicknameUseCase: FetchUserNicknameUseCaseProtocol {

    private let userProfileService: UserProfileProtocol

    public init(
        userProfileService: UserProfileProtocol
    ) {
        self.userProfileService = userProfileService
    }

    public func execute() async throws -> String {
        return try await userProfileService.getUserNickname()
    }
}
