//
//  ManagedSettingsStore.swift
//  CoreAppScreenTime
//
//  Created by Derrick kim on 7/26/25.
//

import CoreAppScreenTimeInterface
import ManagedSettings

public extension ManagedSettingsStore {
    // BlockSchedule에 따라 Shield 설정
    func setShield(_ schedule: BlockSchedule) {
        // FamilyActivitySelection을 Shield에 적용
        shield.applicationCategories = .specific(schedule.blockList.categoryTokens)
        shield.applications = schedule.blockList.applicationTokens
        shield.webDomains = schedule.blockList.webDomainTokens
    }
    
    // Shield 설정 삭제
    func clearShield() {
        shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy<Application>.none
        shield.applications = []
        shield.webDomains = []
    }
}
