//
//  FetchBlockScheduleUseCase.swift
//  DomainScreenTimeManagement
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation
import DomainScreenTimeManagementInterface
import Core

public struct FetchBlockScheduleUseCase: FetchBlockScheduleUseCaseProtocol {
    
    private let blockScheduleManager: BlockScheduleProtocol
    
    public init(blockScheduleManager: BlockScheduleProtocol) {
        self.blockScheduleManager = blockScheduleManager
    }
    
    public func execute(activityName: String) -> BlockScheduleEntity? {
        // Core의 BlockSchedule을 가져와서 Domain Entity로 변환
        guard let blockSchedule = blockScheduleManager.read(activityName) else {
            return nil
        }
        
        // Core BlockSchedule을 Domain BlockScheduleEntity로 변환
        return blockSchedule.toEntity()
    }
}
