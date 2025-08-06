//
//  HandleExtensionTimeExhaustedUseCase.swift
//  DomainScreenTimeManagement
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation
import DomainScreenTimeManagementInterface
import Core

/// 연장 시간이 소진되었을 때 처리하는 UseCase
/// - 사용처: ShieldActionConfigurationExtension에서 최대 연장 횟수에 도달했을 때
/// - 기능: 세션 종료 상태로 변경하고 쿨다운을 시작하여 사용자의 추가 연장을 방지
public struct HandleExtensionTimeExhaustedUseCase: HandleExtensionTimeExhaustedUseCaseProtocol {
    
    private let appScheduleStorage: AppScheduleStorageProtocol
    private let cooldownStorage: CooldownStorageProtocol
    
    public init(
        appScheduleStorage: AppScheduleStorageProtocol,
        cooldownStorage: CooldownStorageProtocol
    ) {
        self.appScheduleStorage = appScheduleStorage
        self.cooldownStorage = cooldownStorage
    }
    
    public func execute(groupName: String, cooldownMinutes: Int) {
        // sessionEnded 상태로 변경
//        let status = BlockingStatus.sessionEnded(
//            time: cooldownMinutes,
//            groupName: groupName
//        )
//        appScheduleStorage.saveBlockingStatus(status)
//        
//        // 쿨다운 시작
//        cooldownStorage.saveCooldownGroup(groupName: groupName)
//        cooldownStorage.startCooldown(minutes: cooldownMinutes)
    }
} 
