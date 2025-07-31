//
//  EndBlockScheduleUseCase.swift
//  DomainScreenTimeManagement
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation
import DomainScreenTimeManagementInterface
import Core

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
