//
//  SessionManager.swift
//  CoreAppScreenTime
//
//  Created by Derrick kim on 2025/01/27.
//

import Foundation
import CoreAppScreenTimeInterface
import CoreLocalStorageInterface
import CoreLocalStorage

@Observable
final class SessionManager {
    static let shared = SessionManager()
    
    private let breakTimeStorage: BreakTimeStorageProtocol = BreakTimeStorage()
    
    var isInCooldown: Bool = false
    var remainingCooldownTime: TimeInterval = 0
    var currentSessionEndTime: Date?
    
    private init() {
        updateCooldownState()
    }
    
    // 세션 시작
    func startSession(for schedule: BlockSchedule, duration: TimeInterval) {
        let endDate = Date().addingTimeInterval(duration)
        DispatchQueue.main.async {
            self.currentSessionEndTime = endDate
        }
    }
    
    // 세션 종료
    func endSession(for schedule: BlockSchedule) {
        DispatchQueue.main.async {
            self.currentSessionEndTime = nil
        }
        
        // 쿨다운 시작 (10분)
        let cooldownMinutes = 10
        breakTimeStorage.saveEndTime(cooldownMinutes)
        updateCooldownState()
    }
    
    // 세션 연장 (스누즈)
    func extendSession(by minutes: Int) {
        guard let currentEndTime = currentSessionEndTime else { return }
        
        let newEndTime = currentEndTime.addingTimeInterval(TimeInterval(minutes * 60))
        DispatchQueue.main.async {
            self.currentSessionEndTime = newEndTime
        }
    }
    
    // 쿨다운 상태 확인
    func updateCooldownState() {
        guard let endTime = breakTimeStorage.getEndTime() else {
            DispatchQueue.main.async {
                self.isInCooldown = false
                self.remainingCooldownTime = 0
            }
            return
        }
        
        let now = Date()
        let isInCooldown = now < endTime
        let remainingTime = max(0, endTime.timeIntervalSince(now))
        
        DispatchQueue.main.async {
            self.isInCooldown = isInCooldown
            self.remainingCooldownTime = remainingTime
        }
    }
    
    // 쿨다운 강제 종료
    func endCooldown() {
        breakTimeStorage.delete()
        updateCooldownState()
    }
    
    // 앱 상태 확인
    func getAppState(for schedule: BlockSchedule) -> AppState {
        if isInCooldown {
            return .inCooldown
        }
        
        if let sessionEndTime = currentSessionEndTime, Date() < sessionEndTime {
            return .inSession
        }
        
        return .blocked
    }
    
    // 세션 시작 가능 여부
    func canStartSession(for schedule: BlockSchedule) -> Bool {
        let state = getAppState(for: schedule)
        return state == .blocked
    }
}

enum AppState {
    case available
    case inSession
    case inCooldown
    case blocked
} 
