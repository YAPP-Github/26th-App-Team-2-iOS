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
    case extensionPrompt(time: Int, count: Int, startDate: Date, endDate: Date) // 3. 휴게시간 연장 가능 상태 --> 쿨다운이 되어야함
    case cooldownActive(tokenName: String, time: Int, groupName: String, startDate: Date, endDate: Date) // 5. 쿨다운 중 앱 진입 시도 - 앱이 쿨다운 상태일 때

    // MARK: - Codable Implementation

    private enum CodingKeys: String, CodingKey {
        case type
        case tokenName
        case time
        case count
        case groupName
        case startDate
        case endDate
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
            let startDate = try container.decode(Date.self, forKey: .startDate)
            let endDate = try container.decode(Date.self, forKey: .endDate)
            self = .extensionPrompt(time: time, count: count, startDate: startDate, endDate: endDate)
//        case "sessionEnded":
//            let time = try container.decode(Int.self, forKey: .time)
//            let groupName = try container.decode(String.self, forKey: .groupName)
//            self = .sessionEnded(time: time, groupName: groupName)
        case "cooldownActive":
            let tokenName = try container.decode(String.self, forKey: .tokenName)
            let time = try container.decode(Int.self, forKey: .time)
            let groupName = try container.decode(String.self, forKey: .groupName)
            let startDate = try container.decode(Date.self, forKey: .startDate)
            let endDate = try container.decode(Date.self, forKey: .endDate)
            self = .cooldownActive(tokenName: tokenName, time: time, groupName: groupName, startDate: startDate, endDate: endDate)
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
        case .extensionPrompt(let time, let count, let startDate, let endDate):
            try container.encode("extensionPrompt", forKey: .type)
            try container.encode(time, forKey: .time)
            try container.encode(count, forKey: .count)
            try container.encode(startDate, forKey: .startDate)
            try container.encode(endDate, forKey: .endDate)
//        case .sessionEnded(let time, let groupName):
//            try container.encode("sessionEnded", forKey: .type)
//            try container.encode(time, forKey: .time)
//            try container.encode(groupName, forKey: .groupName)
        case .cooldownActive(let tokenName, let time, let groupName, let startDate, let endDate):
            try container.encode("cooldownActive", forKey: .type)
            try container.encode(tokenName, forKey: .tokenName)
            try container.encode(time, forKey: .time)
            try container.encode(groupName, forKey: .groupName)
            try container.encode(startDate, forKey: .startDate)
            try container.encode(endDate, forKey: .endDate)
        }
    }

    // MARK: Example 용
    public var title: String {
        switch self {
        case .blocking(let name):
            return "\(name)을 꼭 사용하실건가요?"
        case .unlockedTemporarily:
            return "알림을 눌러 사용 시간을 설정해주세요"
        case .extensionPrompt(_, _, let startDate, let endDate):
            if .now < startDate.addingTimeInterval(60) {
                return "약속한 시간이 지났어요"
            } else if endDate < .now {
                return "name 꼭 사용하실건가요?"
            } else {
                return "지금은 을 사용할 수 없어요"
            }
        case .cooldownActive(let name, _, _, _, _):
            return "지금은 \(name)을 사용할 수 없어요"
        }
    }

    public var subtitle: String {
        switch self {
        case .blocking, .unlockedTemporarily: return ""
        case .extensionPrompt(let time, _, let startDate, let endDate):
            if .now < startDate.addingTimeInterval(60) {
                return ""
            }  else if endDate < .now {
                return ""
            } else {
                return "\(time)분간 을 사용할 수 없어요."
            }
        case .cooldownActive(_, let time, let groupName, _,_ ):
            return "\(time)분간 \(groupName)을 사용할 수 없어요."
        }
    }

    public var primaryButtonTitle: String {
        switch self {
        case .blocking:
            return "사용하기"
        case .unlockedTemporarily:
            return ""
        case .extensionPrompt(_, _, let startDate, let endDate):
            if .now < startDate.addingTimeInterval(60) {
                return "그만하기"
            }  else if endDate < .now {
                return "사용하기"
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
        case .extensionPrompt(let time, _, let startDate, let endDate): // TODO: 5분 간격이 가능해지면 1/2 카운트가 될 수 있음
            if .now < startDate.addingTimeInterval(60) {
                return "\(time)분 더"
            } else if endDate < .now {
                return "안하기"
            } else {
                return "나가기"
            }
        case .cooldownActive:
            return "나가기"

        }
    }

}
