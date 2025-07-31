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
    
    // MARK: - Domain - Service
    var appGroupService: AppGroupProtocol { get }
    
    // MARK: - Domain - UseCase
    var fetchAppGroupUseCase: FetchAppGroupUseCase { get }
    var upsertAppGroupUseCase: UpsertAppGroupUseCase { get }
    var deleteAppGroupUseCase: DeleteAppGroupUseCase { get }
    var requestScreenTimeAuthUseCase: RequestScreenTimeAuthUseCase { get }
}

final class AppGroupDIManager: AppGroupDIContainerProtocol {
    /// 해결 과제:
    /// 1. SwiftData를 MainActor에서 실행함에 따른 Actor 의존성 전파
    /// 2. ModelContext try 생성에 따른 AppGroupStorage 생성자 throws 처리
    @MainActor lazy var appGroupStorage: AppGroupStorageProtocol? = AppGroupStorage()
    
    @MainActor lazy var appGroupService: AppGroupProtocol = AppGroupService(appGroupStorage: appGroupStorage)
    
    @MainActor lazy var fetchAppGroupUseCase: FetchAppGroupUseCase = FetchAppGroupUseCase(appGroupService: appGroupService)
    
    @MainActor lazy var upsertAppGroupUseCase: UpsertAppGroupUseCase = UpsertAppGroupUseCase(appGroupService: appGroupService)
    
    @MainActor lazy var deleteAppGroupUseCase: DeleteAppGroupUseCase = DeleteAppGroupUseCase(appGroupService: appGroupService)
    @MainActor lazy var requestScreenTimeAuthUseCase: RequestScreenTimeAuthUseCase = RequestScreenTimeAuthUseCase()
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
