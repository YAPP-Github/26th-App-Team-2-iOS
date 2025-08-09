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

public final class UserProfileService: ResetLocalStorageProtocol {
    public let networkProvider: NetworkProviderProtocol
    public let onboardingState: OnboardingStateProtocol
    
    
    public let tokenStorage: TokenStorageProtocol
    public let tokenKeyHolder: TokenKeyHolderProtocol
    public let appGroupStorage: AppGroupStorageProtocol?
    public let appScheduleStorage: AppScheduleStorageProtocol
    public let breakTimeStorage: BreakTimeStorageProtocol
    public let cooldownStorage: CooldownStorageProtocol
    public let memberStateStorage: MemberStateStorageProtocol
    public let userDefaultsUserStorage: UserStorageProtocol
    
    
    public init(
        networkProvider: NetworkProviderProtocol,
        onboardingState: OnboardingStateProtocol,
        tokenStorage: TokenStorageProtocol,
        tokenKeyHolder: TokenKeyHolderProtocol,
        appGroupStorage: AppGroupStorageProtocol?,
        appScheduleStorage: AppScheduleStorageProtocol,
        breakTimeStorage: BreakTimeStorageProtocol,
        cooldownStorage: CooldownStorageProtocol,
        memberStateStorage: MemberStateStorageProtocol,
        userDefaultsUserStorage: UserStorageProtocol
    ) {
        self.networkProvider = networkProvider
        self.onboardingState = onboardingState
        
        self.tokenStorage = tokenStorage
        self.tokenKeyHolder = tokenKeyHolder
        self.appGroupStorage = appGroupStorage
        self.appScheduleStorage = appScheduleStorage
        self.breakTimeStorage = breakTimeStorage
        self.cooldownStorage = cooldownStorage
        self.memberStateStorage = memberStateStorage
        self.userDefaultsUserStorage = userDefaultsUserStorage
    }
}
