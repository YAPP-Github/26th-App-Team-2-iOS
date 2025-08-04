//
//  FetchAppNameUseCase.swift
//  DomainScreenTimeManagement
//
//  Created by Derrick kim on 8/3/25.
//

import Foundation
import Core
import DomainScreenTimeManagementInterface

public struct FetchAppNameUseCase: FetchAppNameUseCaseProtocol {
    private let appScheduleStorage: AppScheduleStorageProtocol
    
    public init(appScheduleStorage: AppScheduleStorageProtocol) {
        self.appScheduleStorage = appScheduleStorage
    }
    
    public func execute() async throws -> String? {
        return appScheduleStorage.getAppName()
    }
} 
