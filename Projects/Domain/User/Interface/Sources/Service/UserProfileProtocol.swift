//
//  UserProfileProtocol.swift
//  DomainUser
//
//  Created by Greem on 7/26/25.
//

import Foundation
import Core

public protocol UserProfileProtocol {
    func setUserNickname(_ nickname: String) async throws
    func getUserNickname() async throws -> String
    func deleteUser() async throws
}

public final class UserProfileService {
    public let networkProvider: NetworkProviderProtocol
    public let onboardingState: OnboardingStateProtocol
    public let userStorage: UserStorageProtocol
    public let tokenStorage: TokenStorageProtocol
    
    
    public init(
        networkProvider: NetworkProviderProtocol,
        onboardingState: OnboardingStateProtocol,
        userStorage: UserStorageProtocol,
        tokenStorage: TokenStorageProtocol
    ) {
        self.networkProvider = networkProvider
        self.onboardingState = onboardingState
        self.userStorage = userStorage
        self.tokenStorage = tokenStorage
    }
}
