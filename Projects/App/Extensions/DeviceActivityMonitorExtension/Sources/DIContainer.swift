//
//  DIContainer.swift
//  DeviceActivityMonitorExtension
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation
import Core
import DomainScreenTimeManagement
import DomainScreenTimeManagementInterface

public class DIContainer {
    private var dependencies: [String: Any] = [:]
    
    public init() {
        registerDependencies()
    }
    
    private func registerDependencies() {
        let appScheduleStorage: AppScheduleStorageProtocol = AppScheduleStorage()
        let cooldownStorage: CooldownStorageProtocol = CooldownStorage()
        let blockScheduleManager = BlockScheduleManager()
        let managedSettingsManager = ManagedSettingsStoreManager()

        register(appScheduleStorage)
        register(cooldownStorage)
        register(blockScheduleManager)
        register(managedSettingsManager)

        let snoozeBreakTimeUseCase = SnoozeBreakTimeUseCase(
            appScheduleStorage: appScheduleStorage,
            blockScheduleManager: blockScheduleManager,
            managedSettingsManager: managedSettingsManager
        )
        
        let startBlockScheduleUseCase = StartBlockScheduleUseCase(
            appScheduleStorage: appScheduleStorage,
            blockScheduleManager: blockScheduleManager
        )
        
        let endBreakTimeUseCase = EndBreakTimeUseCase(
            appScheduleStorage: appScheduleStorage,
            blockScheduleManager: blockScheduleManager,
            managedSettingsManager: managedSettingsManager
        )
        
        let endBlockScheduleUseCase = EndBlockScheduleUseCase(
            blockScheduleManager: blockScheduleManager
        )
        
        let clearAllBlockListsUseCase = ClearAllBlockListsUseCase(
            managedSettingsManager: managedSettingsManager
        )
        
        let fetchBlockScheduleUseCase = FetchBlockScheduleUseCase(
            blockScheduleManager: blockScheduleManager
        )

        register(snoozeBreakTimeUseCase)
        register(startBlockScheduleUseCase)
        register(endBreakTimeUseCase)
        register(endBlockScheduleUseCase)
        register(clearAllBlockListsUseCase)
        register(fetchBlockScheduleUseCase)
    }
    
    private func register<T>(_ dependency: T) {
        let key = String(describing: T.self)
        dependencies[key] = dependency
    }
    
    public func resolve<T>() -> T {
        let key = String(describing: T.self)
        guard let dependency = dependencies[key] as? T else {
            fatalError("Dependency not found for type: \(T.self)")
        }
        return dependency
    }
    
    public func makeSnoozeBreakTimeUseCase() -> SnoozeBreakTimeUseCaseProtocol {
        return resolve()
    }
    
    public func makeStartBlockScheduleUseCase() -> StartBlockScheduleUseCaseProtocol {
        return resolve()
    }
    
    public func makeEndBreakTimeUseCase() -> EndBreakTimeUseCaseProtocol {
        return resolve()
    }
    
    public func makeEndBlockScheduleUseCase() -> EndBlockScheduleUseCaseProtocol {
        return resolve()
    }
    
    public func makeClearAllBlockListsUseCase() -> ClearAllBlockListsUseCaseProtocol {
        return resolve()
    }
    
    public func makeFetchBlockScheduleUseCase() -> FetchBlockScheduleUseCaseProtocol {
        return resolve()
    }
} 