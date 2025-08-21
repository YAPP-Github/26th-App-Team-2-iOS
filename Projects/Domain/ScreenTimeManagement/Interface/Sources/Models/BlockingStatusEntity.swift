//
//  BlockingStatusEntity.swift
//  DomainScreenTimeManagementInterface
//
//  Created by Derrick kim on 8/1/25.
//

import Foundation
import ManagedSettings

public enum BlockingStatusEntity {
    case blocking(tokenName: String) // 1. 차단 UI 노출
    case unlockedTemporarily // 2. 임시 사용 허용 상태
    case extensionPrompt(name: String, time: Int, count: Int, startDate: Date, endDate: Date) // 3. 휴게시간 연장 가능 상태
    case cooldownActive(name: String, time: Int, groupName: String, startDate: Date, endDate: Date) // 6. 쿨다운 중 앱 진입 시도 -

    public var title: String {
        switch self {
        case .blocking(let name):
            return "\(name)을 꼭 사용하실건가요?"
        case .unlockedTemporarily:
            return "알림을 눌러 사용 시간을 설정해주세요"
        case .extensionPrompt(let name, _, _, let startDate, _):
            if startDate.addingTimeInterval(60) < .now {
                return "약속한 시간이 지났어요"
            } else {
                return "지금은 \(name)을 사용할 수 없어요"
            }
        case .cooldownActive(let name, _, _, _, _):
            return "지금은 \(name)을 사용할 수 없어요"
        }
    }

    public var subtitle: String {
        switch self {
        case .blocking, .unlockedTemporarily: return ""
        case .extensionPrompt(let name, let time, _, let startDate, _):
            if startDate.addingTimeInterval(60) < .now {
                return ""
            } else {
                return "\(time)분간 \(name)을 사용할 수 없어요."
            }
        case .cooldownActive(_, let time, let groupName, _, _):
            return "\(time)분간 \(groupName)을 사용할 수 없어요."
        }
    }

    public var primaryButtonTitle: String {
        switch self {
        case .blocking:
            return "사용하기"
        case .unlockedTemporarily:
            return ""
        case .extensionPrompt(_, _, _, let startDate, _):
            if startDate.addingTimeInterval(60) < .now {
                return "그만하기"
            } else {
                return "남은 시간 확인"
            }
        case .cooldownActive:
            return "남은 시간 확인"
        }
    }

    public var secondaryButtonTitle: String {
        switch self {
        case .blocking:
            return "안하기"
        case .unlockedTemporarily:
            return "다시 알림 보내기"
        case .extensionPrompt(_, let time, _, let startDate, _): // TODO: 5분 간격이 가능해지면 1/2 카운트가 될 수 있음
            if startDate.addingTimeInterval(60) < .now {
                return "\(time)분 더"
            } else {
                return "나가기"
            }
        case .cooldownActive:
            return "나가기"
        }
    }
    
}
