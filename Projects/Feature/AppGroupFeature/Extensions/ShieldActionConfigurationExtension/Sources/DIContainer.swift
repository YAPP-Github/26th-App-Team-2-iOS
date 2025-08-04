//
//  DIContainer.swift
//  ShieldActionConfigurationExtension
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation
import Domain
import Core

public class DIContainer {
    private var dependencies: [String: Any] = [:]

    public init() {
        registerDependencies()
    }

    private func registerDependencies() {
        let appScheduleStorage: AppScheduleStorageProtocol = AppScheduleStorage()
        let cooldownStorage: CooldownStorageProtocol = CooldownStorage()
        let breakTimeManager = BreakTimeManager()

        register(appScheduleStorage)
        register(cooldownStorage)
        register(breakTimeManager)

        let extendBreakTimeUseCase = ExtendBreakTimeUseCase(
            appScheduleStorage: appScheduleStorage,
            breakTimeManager: breakTimeManager
        )

        let handleExtensionTimeExhaustedUseCase = HandleExtensionTimeExhaustedUseCase(
            appScheduleStorage: appScheduleStorage,
            cooldownStorage: cooldownStorage
        )

        let saveBlockingStatusUseCase = SaveBlockingStatusUseCase(
            appScheduleStorage: appScheduleStorage
        )

        let openAppUseCase = OpenAppUseCase()
        let getBlockingStatusUseCase = GetBlockingStatusUseCase(
            appScheduleStorage: appScheduleStorage,
            cooldownStorage: cooldownStorage
        )
        
        let getExtensionTimeUseCase = GetExtensionTimeUseCase(
            appScheduleStorage: appScheduleStorage
        )

        register(extendBreakTimeUseCase)
        register(handleExtensionTimeExhaustedUseCase)
        register(saveBlockingStatusUseCase)
        register(openAppUseCase)
        register(getBlockingStatusUseCase)
        register(getExtensionTimeUseCase)
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

    public func makeExtendBreakTimeUseCase() -> ExtendBreakTimeUseCaseProtocol {
        return resolve()
    }

    public func makeHandleExtensionTimeExhaustedUseCase() -> HandleExtensionTimeExhaustedUseCaseProtocol {
        return resolve()
    }

    public func makeSaveBlockingStatusUseCase() -> SaveBlockingStatusUseCaseProtocol {
        return resolve()
    }

    public func makeOpenAppUseCase() -> OpenAppUseCaseProtocol {
        return resolve()
    }

    public func makeGetBlockingStatusUseCase() -> GetBlockingStatusUseCaseProtocol {
        return resolve()
    }
    
    public func makeGetExtensionTimeUseCase() -> GetExtensionTimeUseCaseProtocol {
        return resolve()
    }
}
