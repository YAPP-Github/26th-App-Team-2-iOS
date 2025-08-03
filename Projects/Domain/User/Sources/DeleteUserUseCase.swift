//
//  DeleteUserUseCase.swift
//  DomainUser
//
//  Created by Derrick kim on 8/2/25.
//

import Core
import DomainUserInterface

public struct DeleteUserUseCase: DeleteUserUseCaseProtocol {

    private let userProfileService: UserProfileProtocol

    public init(
        userProfileService: UserProfileProtocol
    ) {
        self.userProfileService = userProfileService
    }

    public func execute() async throws {
        try await userProfileService.deleteUser()
    }

}
