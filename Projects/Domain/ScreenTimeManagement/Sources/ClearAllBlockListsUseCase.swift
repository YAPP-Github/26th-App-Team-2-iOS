//
//  ClearAllBlockListsUseCase.swift
//  DomainScreenTimeManagement
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation
import DomainScreenTimeManagementInterface
import Core

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
