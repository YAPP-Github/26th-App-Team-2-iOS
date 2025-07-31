//
//  CooldownStorageProtocol.swift
//  CoreLocalStorageInterface
//
//  Created by Derrick kim on 2025/01/27.
//

import Foundation

public protocol CooldownStorageProtocol {
    /// 쿨다운 시작 (종료 시각 저장)
    func startCooldown(minutes: Int)
    
    /// 쿨다운 종료 시각 조회
    func getCooldownEndTime() -> Date?
    
    /// 현재 쿨다운 상태인지 확인
    func isInCooldown() -> Bool
    
    /// 남은 쿨다운 시간 (초 단위)
    func getRemainingCooldownTime() -> TimeInterval
    
    /// 쿨다운 강제 종료
    func endCooldown()
    
    /// 쿨다운 그룹 정보 저장
    func saveCooldownGroup(groupName: String)
    
    /// 쿨다운 그룹 정보 조회
    func getCooldownGroup() -> String?
    
    /// 쿨다운 관련 모든 데이터 삭제
    func clearCooldownData()
} 
