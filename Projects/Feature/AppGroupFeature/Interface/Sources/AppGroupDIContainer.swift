//
//  DIManager.swift
//  FeatureAppGroupFeature
//
//  Created by Greem on 7/30/25.
//

import Foundation
import Domain
import Core
import SwiftUI

public protocol AppGroupDIContainerProtocol {
    
    // MARK: - Core
    var appGroupStorage: AppGroupStorageProtocol? { get }
    
    var blockSchedule: BlockScheduleProtocol { get }
    var appScheduleStorage: AppScheduleStorageProtocol { get }
    var breakTime: BreakTimeProtocol { get }
    
    // MARK: - Domain - Service
    var appGroupService: AppGroupProtocol { get }
    
    // MARK: - Domain - UseCase
    var fetchAppGroupUseCase: FetchAppGroupUseCase { get }
    var upsertAppGroupUseCase: UpsertAppGroupUseCase { get }
    var deleteAppGroupUseCase: DeleteAppGroupUseCase { get }
    var requestScreenTimeAuthUseCase: RequestScreenTimeAuthUseCase { get }
    
    var createBlockScheduleUseCase: CreateBlockScheduleUseCaseProtocol { get }
    var deleteBlockScheduleUseCase: DeleteBlockScheduleUseCaseProtocol { get }
    var fetchBlockScheduleUseCase: FetchBlockScheduleUseCaseProtocol { get }
    var endBlockScheduleUseCase: EndBlockScheduleUseCaseProtocol { get }
    var createBreakTimeUseCase: CreateBreakTimeUseCaseProtocol { get }
}

final class AppGroupDIManager: AppGroupDIContainerProtocol {
    private(set) lazy var blockSchedule: BlockScheduleProtocol = BlockScheduleManager()
    private(set) lazy var appScheduleStorage: AppScheduleStorageProtocol = AppScheduleStorage()
    private(set) lazy var breakTime: BreakTimeProtocol = BreakTimeManager()
    /// 해결 과제:
    /// 1. SwiftData를 MainActor에서 실행함에 따른 Actor 의존성 전파
    /// 2. ModelContext try 생성에 따른 AppGroupStorage 생성자 throws 처리
    @MainActor private(set) lazy var appGroupStorage: AppGroupStorageProtocol? = AppGroupStorage()
    
    @MainActor private(set) lazy var appGroupService: AppGroupProtocol = AppGroupService(appGroupStorage: appGroupStorage)
    
    @MainActor private(set) lazy var fetchAppGroupUseCase: FetchAppGroupUseCase = FetchAppGroupUseCase(appGroupService: appGroupService)
    
    @MainActor private(set) lazy var upsertAppGroupUseCase: UpsertAppGroupUseCase = UpsertAppGroupUseCase(appGroupService: appGroupService)
    
    @MainActor private(set) lazy var deleteAppGroupUseCase: DeleteAppGroupUseCase = DeleteAppGroupUseCase(appGroupService: appGroupService)
    @MainActor private(set) lazy var requestScreenTimeAuthUseCase: RequestScreenTimeAuthUseCase = RequestScreenTimeAuthUseCase()
    
    private(set) lazy var createBlockScheduleUseCase: CreateBlockScheduleUseCaseProtocol = CreateBlockScheduleUseCase(blockScheduleManager: blockSchedule)
    
    private(set) lazy var deleteBlockScheduleUseCase: DeleteBlockScheduleUseCaseProtocol = DeleteBlockScheduleUseCase(blockScheduleManager: blockSchedule)
    
    private(set) lazy var fetchBlockScheduleUseCase: FetchBlockScheduleUseCaseProtocol = FetchBlockScheduleUseCase(blockScheduleManager: blockSchedule)
    
    private(set) lazy var endBlockScheduleUseCase: EndBlockScheduleUseCaseProtocol = EndBlockScheduleUseCase(blockScheduleManager: blockSchedule)
    
    private(set) lazy var createBreakTimeUseCase: CreateBreakTimeUseCaseProtocol = CreateBreakTimeUseCase(
        breakTimeManager: breakTime,
        appScheduleStorage: appScheduleStorage
    )
}

private struct AppGroupDIContainerKey: EnvironmentKey {
    static let defaultValue: AppGroupDIContainerProtocol = AppGroupDIManager()
}

extension EnvironmentValues {
    public var appGroupDIContainer: AppGroupDIContainerProtocol {
        get {
            self[AppGroupDIContainerKey.self]
        } set {
            self[AppGroupDIContainerKey.self] = newValue
        }
    }
}
