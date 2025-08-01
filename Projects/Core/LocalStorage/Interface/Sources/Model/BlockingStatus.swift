//
//  BlockingStatus.swift
//  CoreLocalStorageInterface
//
//  Created by Derrick kim on 7/29/25.
//

import Foundation
import SharedDesignSystem
import UIKit

public enum BlockingStatus: Codable, Equatable {

    case blocking(tokenName: String) // 1. 차단 UI 노출
    case unlockedTemporarily // 2. 임시 사용 허용 상태
    case extensionPrompt(time: Int, count: Int) // 3. 휴게시간 연장 가능 상태
    case sessionEnded(time: Int, groupName: String) // 5. 세션 종료 (스누즈 2회 후) - 앱이 포그라운드일 때
    case cooldownActive(tokenName: String, time: Int, groupName: String) // 6. 쿨다운 중 앱 진입 시도 - 앱이 쿨다운 상태일 때

    // MARK: - Codable Implementation

    private enum CodingKeys: String, CodingKey {
        case type
        case tokenName
        case time
        case count
        case groupName
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "blocking":
            let tokenName = try container.decode(String.self, forKey: .tokenName)
            self = .blocking(tokenName: tokenName)
        case "unlockedTemporarily":
            self = .unlockedTemporarily
        case "extensionPrompt":
            let time = try container.decode(Int.self, forKey: .time)
            let count = try container.decode(Int.self, forKey: .count)
            self = .extensionPrompt(time: time, count: count)
        case "sessionEnded":
            let time = try container.decode(Int.self, forKey: .time)
            let groupName = try container.decode(String.self, forKey: .groupName)
            self = .sessionEnded(time: time, groupName: groupName)
        case "cooldownActive":
            let tokenName = try container.decode(String.self, forKey: .tokenName)
            let time = try container.decode(Int.self, forKey: .time)
            let groupName = try container.decode(String.self, forKey: .groupName)
            self = .cooldownActive(tokenName: tokenName, time: time, groupName: groupName)
        default:
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Unknown type")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .blocking(let tokenName):
            try container.encode("blocking", forKey: .type)
            try container.encode(tokenName, forKey: .tokenName)
        case .unlockedTemporarily:
            try container.encode("unlockedTemporarily", forKey: .type)
        case .extensionPrompt(let time, let count):
            try container.encode("extensionPrompt", forKey: .type)
            try container.encode(time, forKey: .time)
            try container.encode(count, forKey: .count)
        case .sessionEnded(let time, let groupName):
            try container.encode("sessionEnded", forKey: .type)
            try container.encode(time, forKey: .time)
            try container.encode(groupName, forKey: .groupName)
        case .cooldownActive(let tokenName, let time, let groupName):
            try container.encode("cooldownActive", forKey: .type)
            try container.encode(tokenName, forKey: .tokenName)
            try container.encode(time, forKey: .time)
            try container.encode(groupName, forKey: .groupName)
        }
    }

    // MARK: Example 용
    public var title: String {
        switch self {
        case .blocking(let name):
            return "\(name)을 꼭 사용하실건가요?"
        case .unlockedTemporarily:
            return "알림을 눌러 사용 시간을 설정해주세요"
        case .extensionPrompt:
            return "약속한 시간이 지났어요"
        case .sessionEnded(let time, let groupName):
            return "이제 \(time)분간 \(groupName) 앱을 사용할수 없어요"
        case .cooldownActive(let name, _, _):
            return "지금은 \(name)을 사용할 수 없어요"
        }
    }

    public var subtitle: String {
        switch self {
        case .blocking, .unlockedTemporarily, .extensionPrompt:
            return ""
        case .sessionEnded:
            return "사용 시간이 모두 끝났어요."
        case .cooldownActive(_, let time, let groupName):
            return "\(time)분간 \(groupName)을 사용할 수 없어요."
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
        case .sessionEnded, .cooldownActive:
            return "남은 시간 확인"
        }
    }

    public var secondaryButtonTitle: String {
        switch self {
        case .blocking:
            return "안하기"
        case .unlockedTemporarily:
            return "다시 알림 보내기"
        case .extensionPrompt(let time, _): // TODO: 5분 간격이 가능해지면 1/2 카운트가 될 수 있음
            return "\(time)분 더"
        case .sessionEnded, .cooldownActive:
            return "나가기"

        }
    }

}
