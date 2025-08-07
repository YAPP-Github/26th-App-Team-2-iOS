//
//  CoreDIContainer.swift
//  Brake
//
//  Created by Derrick kim on 2025/08/05.
//

import Foundation
import Core
import SharedUtil

public protocol CoreDIContainerProtocol {
    // MARK: - Network
    func makeNetworkProvider(hasRequestInterceptor: Bool) -> NetworkProviderProtocol
    var tokenInterceptor: TokenInterceptor { get }
    var tokenKeyHolder: TokenKeyHolderProtocol { get }
    
    // MARK: - Storage
    var tokenStorage: TokenStorageProtocol { get }
    var memberStateStorage: MemberStateStorageProtocol { get }
    var userStorage: UserStorageProtocol { get }
    var appGroupStorage: AppGroupStorageProtocol? { get }
    var breakTimeManager: BreakTimeProtocol { get }
    var appScheduleStorage: AppScheduleStorageProtocol { get }
    var cooldownStorage: CooldownStorageProtocol { get }
    var blockScheduleManger: BlockScheduleProtocol { get }
    var managedSettingsManager: ManagedSettingsStoreProtocol { get }
}

public final class CoreDIContainer: @preconcurrency CoreDIContainerProtocol {

    public init() {}

    public lazy var tokenStorage: TokenStorageProtocol = KeyChainTokenStorage()
    public lazy var memberStateStorage: MemberStateStorageProtocol = UserDefaultsMemberStateStorage()
    public lazy var userStorage: UserStorageProtocol = UserDefaultsUserStorage()
    public lazy var tokenKeyHolder: TokenKeyHolderProtocol = BundleTokenKeyHolder()
    
    @MainActor public lazy var tokenInterceptor: TokenInterceptor = TokenInterceptor(
        tokenStorage: tokenStorage,
        tokenKeyHolder: tokenKeyHolder
    )

    @MainActor public func makeNetworkProvider(hasRequestInterceptor: Bool) -> NetworkProviderProtocol {
        return NetworkProvider(
            networkSession: NetworkSession(
                requestInterceptor: hasRequestInterceptor ? tokenInterceptor : nil,
                urlSession: .shared
            ),
            urlComponentConfig: .default
        )
    }
    
    @MainActor public lazy var appGroupStorage: AppGroupStorageProtocol? = AppGroupStorage()
    @MainActor public lazy var breakTimeManager: BreakTimeProtocol = BreakTimeManager()
    @MainActor public lazy var appScheduleStorage: AppScheduleStorageProtocol = AppScheduleStorage()
    @MainActor public lazy var cooldownStorage: CooldownStorageProtocol = CooldownStorage()
    @MainActor public lazy var blockScheduleManger: BlockScheduleProtocol = BlockScheduleManager()
    @MainActor public lazy var managedSettingsManager: ManagedSettingsStoreProtocol = ManagedSettingsStoreManager()
}
