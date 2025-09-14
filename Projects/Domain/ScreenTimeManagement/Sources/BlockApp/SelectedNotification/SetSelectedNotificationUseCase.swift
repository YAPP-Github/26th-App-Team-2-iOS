//
//  SetSelectedNotificationUseCase.swift
//  DomainScreenTimeManagementInterface
//
//  Created by Greem on 9/14/25.
//

import DomainScreenTimeManagementInterface
import Core

public struct SetSelectedNotificationUseCase: SetSelectedNotificationUseCaseProtocol {
    
    private let appScheduleStorage: AppScheduleStorageProtocol
    
    public init(appScheduleStorage: AppScheduleStorageProtocol) {
        self.appScheduleStorage = appScheduleStorage
    }
    
    public func execute(_ selectedNotification: Bool) {
        return appScheduleStorage.saveSelectNotificationTrigger(selectedNotification)
    }
    
}
