//
//  BlockingStatus.swift
//  CoreLocalStorageInterface
//
//  Created by Derrick kim on 7/29/25.
//

import Foundation
import SharedDesignSystem
import UIKit

public enum BlockingStatus {
    case blocking(tokenName: String) // 1. 차단 UI 노출
    case unlockedTemporarily // 2. 임시 사용 허용 상태
    case extensionPrompt(time: String, count: String) // 3. 휴게시간 연장 가능 상태
    case cooldownActive(tokenName: String) // 4. 연장 끝 → 완전 차단
    case blockedAfterExtension(time: String, groupName: String) // 5. 연장 끝 → 완전 차단

    public var title: String {
        switch self {
        case .blocking(let name):
            return "\(name)을 꼭 사용하실건가요?"
        case .unlockedTemporarily:
            return "알림을 눌러 사용 시간을 설정해주세요"
        case .extensionPrompt:
            return "약속한 시간이 지났어요"
        case .cooldownActive(let name):
            return "지금은 \(name)을 사용할 수 없어요"
        case .blockedAfterExtension(let time, let groupName):
            return "이제 \(time)분간 \(groupName) 앱을 사용할수 없어요"
        }
    }

    public var primaryButtonTitle: String {
        switch self {
        case .blocking:
            return "사용하기"
        case .unlockedTemporarily:
            return ""
        case .extensionPrompt:
            return "그만하기"
        case .cooldownActive, .blockedAfterExtension:
            return "남은 시간 확인"
        }
    }

    public var secondaryButtonTitle: String {
        switch self {
        case .blocking:
            return "안하기"
        case .unlockedTemporarily:
            return "다시 알림 보내기"
        case .extensionPrompt(let time, let count):
            return "\(time)분 더(\(count)/2)"
        case .cooldownActive, .blockedAfterExtension:
            return "나가기"

        }
    }

}
