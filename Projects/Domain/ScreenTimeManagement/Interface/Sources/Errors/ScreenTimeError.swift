//
//  ScreenTimeError.swift
//  DomainScreenTimeManagementInterface
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation

public enum ScreenTimeError: LocalizedError {
    case breakTimeCreationFailed(underlying: Error)
    case invalidBreakTimeDuration(minutes: Int)
    case storageOperationFailed(underlying: Error)
    case extensionTimeExhausted
    case blockScheduleNotFound
    
    public var errorDescription: String? {
        switch self {
        case .breakTimeCreationFailed(let underlying):
            return "휴식 시간 생성에 실패했습니다: \(underlying.localizedDescription)"
        case .invalidBreakTimeDuration(let minutes):
            return "휴식 시간은 최소 15분 이상이어야 합니다. 현재: \(minutes)분"
        case .storageOperationFailed(let underlying):
            return "저장소 작업에 실패했습니다: \(underlying.localizedDescription)"
        case .extensionTimeExhausted:
            return "연장 가능한 시간을 모두 사용했습니다"
        case .blockScheduleNotFound:
            return "차단 스케줄을 찾을 수 없습니다"
        }
    }
} 
