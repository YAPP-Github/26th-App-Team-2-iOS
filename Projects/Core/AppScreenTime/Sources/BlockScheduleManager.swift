//
//  BlockScheduleManager.swift
//  CoreAppScreenTime
//
//  Created by Derrick kim on 7/24/25.
//

import Foundation
import DeviceActivity
import CoreAppScreenTimeInterface
import CoreLocalStorage
import CoreLocalStorageInterface
import FamilyControls

public struct BlockScheduleManager: BlockScheduleProtocol {

    private let center = DeviceActivityCenter()
    private let managedSettingsManager = ManagedSettingsStoreManager()
    private let appScheduleStorage: AppScheduleStorageProtocol = AppScheduleStorage()

    public init() { }

    // 차단 앱 스케줄 추가
    public func create(_ model: BlockSchedule) throws {
        // 스케줄 저장
        try save(model)

        // 이미 등록된 모니터링이 있으면 update로 우회
        try center.startMonitoring(model)
        
        // 블록 리스트 설정
        managedSettingsManager.updateBlockList(for: model)
    }
    
    // 차단 앱 스케줄 삭제
    public func delete(_ schedule: BlockSchedule) {
        center.stopMonitoring([.brake])
        // 블록 리스트 삭제
        managedSettingsManager.clearBlockList(for: schedule)
    }

    // 차단 앱 스케줄 업데이트
    public func update(_ schedule: BlockSchedule) throws {
        delete(schedule)
        try create(schedule)
    }
    
    // 스케줄 활성화/비활성화에 따른 블록 리스트 관리
    public func updateBlockListBasedOnState(for model: BlockSchedule, isActive: Bool) {
        managedSettingsManager.updateBlockListBasedOnState(for: model, isActive: isActive)
    }
    
    public func startBlockSchedule(_ schedule: BlockSchedule) {
        // 블록 리스트 적용
        managedSettingsManager.updateBlockList(for: schedule)
    }
    
    public func endBlockSchedule(_ schedule: BlockSchedule) {        
        // 1. 특정 스케줄의 블록 리스트 해제
        managedSettingsManager.clearBlockList(for: schedule)
        
        // 2. 추가적으로 모든 블록 리스트를 해제하는 방법도 시도
        managedSettingsManager.clearAllBlockListsForRest(schedules: [])
    }
    
    // 모든 블록 스케줄 업데이트
    public func update() {
        // 저장된 모든 스케줄에 대해 블록 리스트 적용
        // 실제 구현에서는 저장된 스케줄들을 불러와서 적용
        managedSettingsManager.updateAllBlockLists(schedules: [])
    }
    
    // BlockSchedule을 DeviceActivityName으로부터 생성
    public func read(_ id: String) -> BlockSchedule? {
        // AppScheduleStorage에서 저장된 BlockSchedule Data 조회 후 디코딩
        guard let data = appScheduleStorage.getBlockScheduleData(forId: id) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(BlockSchedule.self, from: data)
        } catch {
            return nil
        }
    }
    
    // 모든 BlockSchedule 조회
    public func readAll() -> [BlockSchedule] {
        let allIds = appScheduleStorage.getAllBlockScheduleIds()
        let schedules = allIds.compactMap { id in
            return read(id)
        }

        return schedules
    }
    
    // BlockSchedule 저장
    public func save(_ schedule: BlockSchedule) throws {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(schedule)
            appScheduleStorage.saveBlockScheduleData(data, forId: schedule.id)
        } catch {
            throw error
        }
    }
    
    // BlockSchedule 삭제
    public func remove(_ id: String) {
        appScheduleStorage.deleteBlockSchedule(id: id)
    }

}
