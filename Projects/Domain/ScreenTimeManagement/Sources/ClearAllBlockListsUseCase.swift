//
//  ClearAllBlockListsUseCase.swift
//  DomainScreenTimeManagement
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation
import DomainScreenTimeManagementInterface
import Core

/// 모든 앱 차단 리스트를 해제하는 UseCase
/// - 사용처: ContentView에서 모든 앱 차단을 해제할 때
/// - 기능: ManagedSettings를 통해 모든 앱 차단을 일시적으로 해제
public struct ClearAllBlockListsUseCase: ClearAllBlockListsUseCaseProtocol {
    
    private let managedSettingsManager: ManagedSettingsStoreProtocol

    public init(managedSettingsManager: ManagedSettingsStoreProtocol) {
        self.managedSettingsManager = managedSettingsManager
    }
    
    public func execute() throws {
        // 모든 차단 리스트 해제
        managedSettingsManager.clearAllBlockListsForRest(schedules: [])
    }
} 
