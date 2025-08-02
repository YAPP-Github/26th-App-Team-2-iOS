//
//  CreateBlockScheduleUseCase.swift
//  DomainScreenTimeManagement
//
//  Created by Derrick kim on 8/1/25.
//

import Foundation
import DomainScreenTimeManagementInterface
import Core
import FamilyControls

/// 앱 차단 스케줄을 생성하는 UseCase
/// - 사용처: ContentView에서 사용자가 앱을 차단할 때
/// - 기능: 선택된 앱들에 대해 차단 스케줄을 생성하여 ScreenTime 제한을 설정
public struct CreateBlockScheduleUseCase: CreateBlockScheduleUseCaseProtocol {
    
    private let blockScheduleManager: BlockScheduleProtocol
    
    public init(blockScheduleManager: BlockScheduleProtocol) {
        self.blockScheduleManager = blockScheduleManager
    }
    
    public func execute(schedule: BlockScheduleEntity) throws {
        try blockScheduleManager.create(schedule.toRequest())
    }
} 
