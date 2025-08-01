//
//  GetExtensionTimeUseCase.swift
//  DomainScreenTimeManagement
//
//  Created by Derrick kim on 8/1/25.
//

import Foundation
import DomainScreenTimeManagementInterface
import Core

/// 연장 시간을 조회하는 UseCase
/// - 사용처: ShieldActionConfigurationExtension에서 연장 시간이 소진되었을 때 쿨다운 시간을 확인할 때
/// - 기능: 저장된 연장 시간을 조회하여 쿨다운 설정에 사용
public struct GetExtensionTimeUseCase: GetExtensionTimeUseCaseProtocol {
    
    private let appScheduleStorage: AppScheduleStorageProtocol
    
    public init(appScheduleStorage: AppScheduleStorageProtocol) {
        self.appScheduleStorage = appScheduleStorage
    }
    
    public func execute() -> Int {
        return appScheduleStorage.getExtensionTime()
    }
} 
