//
//  FetchBlockScheduleUseCase.swift
//  DomainScreenTimeManagement
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation
import DomainScreenTimeManagementInterface
import Core

/// 앱 차단 스케줄을 조회하는 UseCase
/// - 사용처: ContentView에서 기존 차단 스케줄을 확인할 때
/// - 기능: 특정 앱의 차단 스케줄을 조회하여 Domain Entity로 변환하여 반환
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
