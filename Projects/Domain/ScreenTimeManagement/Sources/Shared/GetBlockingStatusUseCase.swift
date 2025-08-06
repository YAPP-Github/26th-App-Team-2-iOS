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
        appScheduleStorage.saveAppName(tokenName)
        return validatedStatus.toEntity()
    }
    
    private func validateAndFixStatus(_ status: BlockingStatus, tokenName: String) -> BlockingStatus {
        switch status {
        case .cooldownActive:
            return validateCooldownStatus(tokenName: tokenName)
        default:
            return status
        }
    }
    
    private func validateCooldownStatus(tokenName: String) -> BlockingStatus {
        if !cooldownStorage.isInCooldown() {
            print("쿨다운이 아닌 상태로 떨어진다.")
            // 쿨다운이 종료되었는데 아직 cooldownActive 상태라면 기본 차단 상태로 변경
            let blockingStatus = BlockingStatus.blocking(tokenName: tokenName)
            appScheduleStorage.saveBlockingStatus(blockingStatus)
            return blockingStatus
        }
        
        guard let endTime = cooldownStorage.getCooldownEndTime(),
              let startTime = cooldownStorage.getCooldownStartTime() else {
            print("endTime과 startTime을 가져오지 못함")
            let blockingStatus = BlockingStatus.blocking(tokenName: tokenName)
            appScheduleStorage.saveBlockingStatus(blockingStatus)
            return blockingStatus
        }
        print("validateCooldownStatus - startTime: \(startTime) / endTime: \(endTime)")
        
        return .cooldownActive(tokenName: "앱 그룹", time: Int(cooldownStorage.getRemainingCooldownTime()), groupName: "", startDate: startTime, endDate: endTime)
    }
    
    private func handleSessionEndedStatus() -> BlockingStatus {
        startCooldownFromSessionEnd()
        
        guard let endTime = cooldownStorage.getCooldownEndTime(),
              let startTime = cooldownStorage.getCooldownStartTime() else {
            assertionFailure("시작 시간과 끝 시간을 가져오지 못 함")
            return .blocking(tokenName: "")
        }
        print("handleSessionEndedStatus - startTime: \(startTime) / endTime: \(endTime)")
        print("appScheduleStorage.getExtensionTime() \(appScheduleStorage.getExtensionTime())")
        return .cooldownActive(
            tokenName: "앱 그룹",
            time: appScheduleStorage.getExtensionTime(),
            groupName: "",
            startDate: startTime,
            endDate: endTime
        )
    }
    
    private func startCooldownFromSessionEnd() {
        let cooldownMinutes = appScheduleStorage.getExtensionTime()
        let startDate = Date.now
        let endDate = startDate.addingTimeInterval(TimeInterval(cooldownMinutes * 60))
        
        cooldownStorage.saveCooldownGroup(groupName: "앱 그룹")
        cooldownStorage.startCooldown(minutes: cooldownMinutes)
        
        // 쿨다운 상태로 변경
        appScheduleStorage.saveBlockingStatus(
            .cooldownActive(
                tokenName: "앱 그룹",
                time: cooldownMinutes,
                groupName: "",
                startDate: startDate,
                endDate: endDate
            )
        )
    }
} 
