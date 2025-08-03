//
//  FetchSelectedNotificationUseCase.swift
//  DomainScreenTimeManagement
//
//  Created by Derrick kim on 8/3/25.
//

import DomainScreenTimeManagementInterface
import Core

public struct FetchSelectedNotificationUseCase: FetchSelectedNotificationUseCaseProtocol {

    private let appScheduleStorage: AppScheduleStorageProtocol

    public init(appScheduleStorage: AppScheduleStorageProtocol) {
        self.appScheduleStorage = appScheduleStorage
    }

    public func execute() async throws -> Bool {
        return appScheduleStorage.getSelectedNotification()
    }


}
