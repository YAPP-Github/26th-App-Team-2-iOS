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
    var appGroupStorage: AppGroupStorageProtocol { get }
    
    // MARK: - Domain - Service
    var appGroupService: AppGroupProtocol { get }
    
    // MARK: - Domain - UseCase
    
    var fetchAppGroupUseCase: FetchAppGroupUseCase { get }
    var upsertAppGroupUseCase: UpsertAppGroupUseCase { get }
    var deleteAppGroupUseCase: DeleteAppGroupUseCase { get }
    var requestScreenTimeAuthUseCase: RequestScreenTimeAuthUseCase { get }
}

final class AppGroupDIManager: AppGroupDIContainerProtocol {
    lazy var appGroupStorage: AppGroupStorageProtocol = AppGroupStorage()
    
    lazy var appGroupService: AppGroupProtocol = AppGroupService(appGroupStorage: appGroupStorage)
    
    lazy var fetchAppGroupUseCase: FetchAppGroupUseCase = FetchAppGroupUseCase(appGroupService: appGroupService)
    
    lazy var upsertAppGroupUseCase: UpsertAppGroupUseCase = UpsertAppGroupUseCase(appGroupService: appGroupService)
    
    lazy var deleteAppGroupUseCase: DeleteAppGroupUseCase = DeleteAppGroupUseCase(appGroupService: appGroupService)
    lazy var requestScreenTimeAuthUseCase: RequestScreenTimeAuthUseCase = RequestScreenTimeAuthUseCase()
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
