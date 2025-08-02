//
//  EndBlockScheduleUseCase.swift
//  DomainScreenTimeManagement
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation
import DomainScreenTimeManagementInterface
import Core

/// 앱 차단 스케줄을 종료하는 UseCase
/// - 사용처: ContentView에서 앱 차단을 해제할 때
/// - 기능: 차단 스케줄을 종료하여 앱 차단을 해제
public struct EndBlockScheduleUseCase: EndBlockScheduleUseCaseProtocol {
    
    private let blockScheduleManager: BlockScheduleProtocol

    public init(blockScheduleManager: BlockScheduleProtocol) {
        self.blockScheduleManager = blockScheduleManager
    }
    
    public func execute(schedule: BlockScheduleEntity) throws {
        // 스케줄 종료 시 차단 상태 해제
        blockScheduleManager.endBlockSchedule(schedule.toRequest())
    }
} 
