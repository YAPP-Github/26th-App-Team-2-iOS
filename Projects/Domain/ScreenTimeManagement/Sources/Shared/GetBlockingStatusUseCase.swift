//
//  GetBlockingStatusUseCase.swift
//  DomainScreenTimeManagement
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation
import DomainScreenTimeManagementInterface
import Core

/// 현재 차단 상태를 조회하고 검증하는 UseCase
/// - 사용처: ShieldConfigurationExtension, ShieldActionConfigurationExtension에서 현재 차단 상태를 확인할 때
/// - 기능: 저장된 차단 상태를 조회하고, 쿨다운이나 세션 종료 상태를 검증하여 올바른 상태로 수정
public struct GetBlockingStatusUseCase: GetBlockingStatusUseCaseProtocol {
    
    private let appScheduleStorage: AppScheduleStorageProtocol
    private let cooldownStorage: CooldownStorageProtocol
    
    public init(
        appScheduleStorage: AppScheduleStorageProtocol,
        cooldownStorage: CooldownStorageProtocol
    ) {
        self.appScheduleStorage = appScheduleStorage
        self.cooldownStorage = cooldownStorage
    }
    
    public func execute(tokenName: String) -> BlockingStatusEntity {
        let status = appScheduleStorage.getBlockingStatus() ?? .blocking(tokenName: tokenName)
        let validatedStatus = validateAndFixStatus(status, tokenName: tokenName)
        return validatedStatus.toEntity()
    }
    
    private func validateAndFixStatus(_ status: BlockingStatus, tokenName: String) -> BlockingStatus {
        switch status {
        case .cooldownActive:
            return validateCooldownStatus(tokenName: tokenName)
        case .sessionEnded:
            return handleSessionEndedStatus()
        default:
            return status
        }
    }
    
    private func validateCooldownStatus(tokenName: String) -> BlockingStatus {
        if !cooldownStorage.isInCooldown() {
            // 쿨다운이 종료되었는데 아직 cooldownActive 상태라면 기본 차단 상태로 변경
            let blockingStatus = BlockingStatus.blocking(tokenName: tokenName)
            appScheduleStorage.saveBlockingStatus(blockingStatus)
            return blockingStatus
        }
        return .cooldownActive(tokenName: "앱 그룹", time: 0, groupName: "")
    }
    
    private func handleSessionEndedStatus() -> BlockingStatus {
        startCooldownFromSessionEnd()
        return .cooldownActive(tokenName: "앱 그룹", time: appScheduleStorage.getExtensionTime(), groupName: "")
    }
    
    private func startCooldownFromSessionEnd() {
        let cooldownMinutes = appScheduleStorage.getExtensionTime()
        
        cooldownStorage.saveCooldownGroup(groupName: "앱 그룹")
        cooldownStorage.startCooldown(minutes: cooldownMinutes)
        
        // 쿨다운 상태로 변경
        appScheduleStorage.saveBlockingStatus(
            .cooldownActive(
                tokenName: "앱 그룹",
                time: cooldownMinutes,
                groupName: ""
            )
        )
    }
} 
