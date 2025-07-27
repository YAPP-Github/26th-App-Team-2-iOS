//
//  BlockState.swift
//  CoreAppScreenTime
//
//  Created by Derrick kim on 7/23/25.
//

import Foundation
import FamilyControls
import SharedUtil

public struct BlockState {
    // 차단 상태 열거형
    public enum Status: CustomStringConvertible, Comparable {
        case active  // 진행중
        case rest    // 휴식 상태 (스누즈, 쿨다운 등)

        public var description: String {
            switch self {
            case .active: return "진행중"
            case .rest: return "휴식"
            }
        }
    }
    // 상태
    public let status: Status
    // 남은 시간
    public let remainingTime: TimeInterval

    public init(
        status: Status,
        remainingTime: TimeInterval
    ) {
        self.status = status
        self.remainingTime = remainingTime
    }
}

// 진행중, 휴식 상태에 따른 정렬을 위해 Comparable 채택
extension BlockState: Comparable {
    public static func < (lhs: BlockState, rhs: BlockState) -> Bool {
        guard lhs.status == rhs.status else { return
            lhs.status < rhs.status
        }
        return lhs.remainingTime < rhs.remainingTime
    }

    public static func == (lhs: BlockState, rhs: BlockState) -> Bool {
        return lhs.status == rhs.status && lhs.remainingTime == rhs.remainingTime
    }
}
