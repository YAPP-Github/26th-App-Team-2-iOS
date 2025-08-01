//
//  SaveBlockingStatusUseCase.swift
//  DomainScreenTimeManagement
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation
import DomainScreenTimeManagementInterface
import Core

/// 차단 상태를 저장하는 UseCase
/// - 사용처: ShieldActionConfigurationExtension에서 차단 상태를 변경할 때
/// - 기능: Domain의 BlockingStatusEntity를 Core의 BlockingStatus로 변환하여 저장
public struct SaveBlockingStatusUseCase: SaveBlockingStatusUseCaseProtocol {
    
    private let appScheduleStorage: AppScheduleStorageProtocol
    
    public init(appScheduleStorage: AppScheduleStorageProtocol) {
        self.appScheduleStorage = appScheduleStorage
    }
    
    public func execute(_ status: BlockingStatusEntity) {
        appScheduleStorage.saveBlockingStatus(status.toCore())
    }
} 
