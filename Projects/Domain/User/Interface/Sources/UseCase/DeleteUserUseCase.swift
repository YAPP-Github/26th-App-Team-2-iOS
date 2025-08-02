//
//  DeleteUserUseCase.swift
//  DomainUserInterface
//
//  Created by Greem on 8/2/25.
//

import Foundation

public protocol DeleteUserUseCaseProtocol {
    func execute() async throws
}

public struct DeleteUserUseCase: DeleteUserUseCaseProtocol {
    private let userProfileService: UserProfileProtocol
    
    public init(userProfileService: UserProfileProtocol) {
        self.userProfileService = userProfileService
    }
    
    public func execute() async throws {
        try await userProfileService.deleteUser()
    }
}
