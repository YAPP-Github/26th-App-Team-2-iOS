//
//  DeleteBlockScheduleUseCase.swift
//  DomainScreenTimeManagement
//
//  Created by Derrick kim on 8/1/25.
//

import Foundation
import DomainScreenTimeManagementInterface
import Core

/// 앱 차단 스케줄을 삭제하는 UseCase
/// - 사용처: ContentView에서 사용자가 앱 차단을 해제할 때
/// - 기능: 기존에 설정된 앱 차단 스케줄을 삭제하여 ScreenTime 제한을 해제
public struct DeleteBlockScheduleUseCase: DeleteBlockScheduleUseCaseProtocol {
    
    private let blockScheduleManager: BlockScheduleProtocol
    
    public init(blockScheduleManager: BlockScheduleProtocol) {
        self.blockScheduleManager = blockScheduleManager
    }
    
    public func execute(schedule: BlockScheduleEntity) {
        blockScheduleManager.delete(schedule.toRequest())
    }
} 
