//
//  ManagedSettingsStoreManager.swift
//  CoreAppScreenTime
//
//  Created by Derrick kim on 2025/01/27.
//

import Foundation
import DeviceActivity
import FamilyControls
import ManagedSettings
import CoreAppScreenTimeInterface

// ManagedSettingsStore 관리자
// BlockSchedule의 블록 리스트를 관리
// 휴식 시 블록 리스트를 비워줌
public struct ManagedSettingsStoreManager: ManagedSettingsStoreProtocol {

    public init() { }

    // 블록 리스트 업데이트
    public func updateBlockList(for schedule: BlockSchedule) {
        let center = center(for: schedule)
        center.setShield(schedule)
    }
    
    // 휴식 시 블록 리스트를 비워줌
    public func clearBlockList(for schedule: BlockSchedule) {
        let center = center(for: schedule)
        center.clearShield()
    }

    // 모든 스케줄의 블록 리스트 삭제
    public func clearAllBlockLists(schedules: [BlockSchedule]) {
        schedules.forEach { schedule in
            clearBlockList(for: schedule)
        }
    }
    
    // 휴식 시 모든 블록 리스트를 비워줌
    public func clearAllBlockListsForRest(schedules: [BlockSchedule]) {
        schedules.forEach { schedule in
            clearBlockList(for: schedule)
        }
    }
    
    // schedule과 매칭되는 ManagedSettingsStore를 반환
    private func center(for schedule: BlockSchedule) -> ManagedSettingsStore {
        let storeName = ManagedSettingsStore.Name(id: schedule.id)
        let center = ManagedSettingsStore(named: storeName)
        
        return center
    }
}
