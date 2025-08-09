//
//  ResetLocalStorageProtocol.swift
//  CoreLocalStorage
//
//  Created by Greem on 8/10/25.
//

import Foundation

public protocol ResetLocalStorageProtocol {
    var tokenStorage: TokenStorageProtocol { get }
    var tokenKeyHolder: TokenKeyHolderProtocol { get }
    var appGroupStorage: AppGroupStorageProtocol? { get }
    var appScheduleStorage: AppScheduleStorageProtocol { get }
    var breakTimeStorage: BreakTimeStorageProtocol { get } // 이건 로컬 스토리지가 아님...
    var cooldownStorage: CooldownStorageProtocol { get }
    var memberStateStorage: MemberStateStorageProtocol { get }
    var userDefaultsUserStorage: UserStorageProtocol { get }
    func localStorageReset() async throws
}

public extension ResetLocalStorageProtocol {
    func localStorageReset() async throws {
        try await tokenStorage.deleteAllTokens()
        try await appGroupStorage?.deleteAllAppGroupEntities()
//        appScheduleStorage.deleteBlockSchedule(id: <#T##String#>)
        breakTimeStorage.delete()
        cooldownStorage.clearCooldownData()
        memberStateStorage.save(memberState: .hold)
        userDefaultsUserStorage.deleteNickname()
    }
}
