//
//  DeviceActivityMonitorExtension.swift
//  Brake
//
//  Created by Derrick kim on 7/11/25.
//

import DeviceActivity
import Foundation
import ManagedSettings
import DomainScreenTimeManagementInterface

class DeviceActivityMonitorExtension: DeviceActivityMonitor {

    private let snoozeBreakTimeUseCase: SnoozeBreakTimeUseCaseProtocol
    private let startBlockScheduleUseCase: StartBlockScheduleUseCaseProtocol
    private let endBreakTimeUseCase: EndBreakTimeUseCaseProtocol
    private let endBlockScheduleUseCase: EndBlockScheduleUseCaseProtocol
    private let clearAllBlockListsUseCase: ClearAllBlockListsUseCaseProtocol
    private let fetchBlockScheduleUseCase: FetchBlockScheduleUseCaseProtocol

    override init() {
        let container = DIContainer()

        self.snoozeBreakTimeUseCase = container.makeSnoozeBreakTimeUseCase()
        self.startBlockScheduleUseCase = container.makeStartBlockScheduleUseCase()
        self.endBreakTimeUseCase = container.makeEndBreakTimeUseCase()
        self.endBlockScheduleUseCase = container.makeEndBlockScheduleUseCase()
        self.clearAllBlockListsUseCase = container.makeClearAllBlockListsUseCase()
        self.fetchBlockScheduleUseCase = container.makeFetchBlockScheduleUseCase()

        super.init()
    }

    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        setupStartAction(by: activity)
    }

    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        setupEndAction(by: activity)
    }

    private func setupStartAction(by activity: DeviceActivityName) {
        do {
            if activity == .brake {
                // 스누즈 15분 휴식 처리
                try snoozeBreakTimeUseCase.execute()
            } else if let schedule = fetchBlockScheduleUseCase.execute(activityName: activity.rawValue) {
                // 앱 차단 시작 처리
                try startBlockScheduleUseCase.execute(schedule: schedule)
            } else {
                // BlockSchedule을 찾을 수 없는 경우 - 모든 차단 해제
                try clearAllBlockListsUseCase.execute()
            }
        } catch {
            // 에러 처리
        }
    }

    private func setupEndAction(by activity: DeviceActivityName) {
        do {
            if activity == .brake {
                // 휴식 시간 종료 처리
                try endBreakTimeUseCase.execute()
            } else if let schedule = fetchBlockScheduleUseCase.execute(activityName: activity.rawValue) {
                // 차단 스케줄 종료 처리
                try endBlockScheduleUseCase.execute(schedule: schedule)
            } else {
                // BlockSchedule을 찾을 수 없는 경우 - 모든 차단 해제
                try clearAllBlockListsUseCase.execute()
            }
        } catch {
            // 에러 처리
        }
    }

}
