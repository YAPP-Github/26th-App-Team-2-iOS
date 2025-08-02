//
//  ExtendBreakTimeUseCase.swift
//  DomainScreenTimeManagement
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation
import DomainScreenTimeManagementInterface
import Core

/// 차단 화면에서 휴식 시간을 연장하는 UseCase
/// - 사용처: ShieldActionConfigurationExtension에서 "그만하기" 버튼을 눌렀을 때
/// - 기능: 현재 휴식 시간을 연장하고 연장 횟수를 관리하며, 최대 연장 횟수 제한을 확인
public struct ExtendBreakTimeUseCase: ExtendBreakTimeUseCaseProtocol {
    
    private let appScheduleStorage: AppScheduleStorageProtocol
    private let breakTimeManager: BreakTimeProtocol
    
    public init(
        appScheduleStorage: AppScheduleStorageProtocol,
        breakTimeManager: BreakTimeProtocol
    ) {
        self.appScheduleStorage = appScheduleStorage
        self.breakTimeManager = breakTimeManager
    }
    
    public func execute(time: Int, count: Int) throws -> Bool {
        let maxExtensions = 1
        
        if count < maxExtensions {
            // 연장 횟수 증가
            let newCount = count + 1
            appScheduleStorage.saveExtensionCount(newCount)
            
            // 연장 시간 설정 및 저장
            appScheduleStorage.saveExtensionTime(time)
            
            // DeviceActivity로 연장 시간 설정
            try startExtensionBreakTime(minutes: time)
            
            // 연장 프롬프트 상태 업데이트
            appScheduleStorage.saveBlockingStatus(.extensionPrompt(time: time, count: newCount))
            
            return true // 연장 성공
        } else {
            // 최대 연장 횟수 도달
            return false // 연장 실패
        }
    }
    
    private func startExtensionBreakTime(minutes: Int) throws {
        do {
            try breakTimeManager.createBreakTime(minutes: minutes)
            appScheduleStorage.saveSelectNotificationTrigger(false)
        } catch {
            throw ScreenTimeError.breakTimeCreationFailed(underlying: error)
        }
    }
} 
