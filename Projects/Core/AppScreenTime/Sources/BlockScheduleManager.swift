//
//  BlockScheduleManager.swift
//  CoreAppScreenTime
//
//  Created by Derrick kim on 7/24/25.
//

import Foundation
import DeviceActivity
import CoreAppScreenTimeInterface

public struct BlockScheduleManager: BlockScheduleProtocol {

    private let center = DeviceActivityCenter()

    public init() { }

    // 차단 앱 스케줄 추가
    public func create(_ model: BlockSchedule) throws {
        try center.startMonitoring(model)
    }
    
    // 차단 앱 스케줄 삭제
    public func delete(_ model: BlockSchedule) {
        let name = DeviceActivityName(model.id)
        center.stopMonitoring([name])
    }

    // 차단 앱 스케줄 업데이트
    public func update(_ model: BlockSchedule) throws {
        delete(model)
        try create(model)
    }
}
