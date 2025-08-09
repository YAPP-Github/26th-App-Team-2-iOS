//
//  OAuthLogoutService.swift
//  DomainOAuth
//
//  Created by Derrick kim on 8/2/25.
//

import DomainOAuthInterface
import Foundation
import Core

public final class OAuthLogoutService: OAuthLogoutServiceProtocol, ResetLocalStorageProtocol {
    
    

    private let networkProvider: NetworkProviderProtocol
    
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
        self.tokenStorage = tokenStorage
        self.tokenKeyHolder = tokenKeyHolder
        self.appGroupStorage = appGroupStorage
        self.appScheduleStorage = appScheduleStorage
        self.breakTimeStorage = breakTimeStorage
        self.cooldownStorage = cooldownStorage
        self.memberStateStorage = memberStateStorage
        self.userDefaultsUserStorage = userDefaultsUserStorage
    }

    public func logout() async throws {
        let accessTokenKey: String = try self.tokenKeyHolder.fetchAccessTokenKey()
        let accessToken: AccessToken? = try await tokenStorage.read(key: accessTokenKey)

        guard let accessToken = accessToken else {
            throw AuthError.invalidToken
        }

        let endPoint: BrakeRouter.AuthEndPoint<EmptyData> = BrakeRouter.AuthEndPoint<EmptyData>.logout
        do {
            let _: EmptyData = try await networkProvider.request(endPoint)
        } catch {
            fatalError("에러 던지기: \(error)")
        }
        try await localStorageReset()
    }
}
