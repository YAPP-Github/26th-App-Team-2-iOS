//
//  DIContainer.swift
//  ShieldConfigurationExtension
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation
import Core
import Domain

public class DIContainer {
    private var dependencies: [String: Any] = [:]
    
    public init() {
        registerDependencies()
    }
    
    private func registerDependencies() {
        let appScheduleStorage: AppScheduleStorageProtocol = AppScheduleStorage()
        let cooldownStorage: CooldownStorageProtocol = CooldownStorage()

        register(appScheduleStorage)
        register(cooldownStorage)

        let getBlockingStatusUseCase = GetBlockingStatusUseCase(
            appScheduleStorage: appScheduleStorage,
            cooldownStorage: cooldownStorage
        )
        
        let saveBlockingStatusUseCase = SaveBlockingStatusUseCase(
            appScheduleStorage: appScheduleStorage
        )

        register(getBlockingStatusUseCase)
        register(saveBlockingStatusUseCase)
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
    
    public func makeGetBlockingStatusUseCase() -> GetBlockingStatusUseCaseProtocol {
        return resolve()
    }
    
    public func makeSaveBlockingStatusUseCase() -> SaveBlockingStatusUseCaseProtocol {
        return resolve()
    }

}
