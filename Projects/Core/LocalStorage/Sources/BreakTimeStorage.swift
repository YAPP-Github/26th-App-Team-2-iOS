//
//  BreakTimeStorage.swift
//  CoreLocalStorage
//
//  Created by Derrick kim on 7/24/25.
//

import Foundation
import CoreLocalStorageInterface

public struct BreakTimeStorage: BreakTimeStorageProtocol {
    public let userDefaults: UserDefaults? = UserDefaults(suiteName: Bundle.main.appGroupName)

    public init() { }

    private enum Keys {
        static let breakEndTime = "breakEndTime"
    }

    // 휴식 종료시간 설정
    public func saveEndTime(_ minutes: Int) {
        let calendar = Calendar.current
        let endTime = calendar.date(byAdding: .minute, value: minutes, to: Date())
        userDefaults?.set(endTime, forKey: Keys.breakEndTime)
    }

    // 휴식 종료시간 읽기
    public func getEndTime() -> Date? {
        guard let endTime = userDefaults?.value(forKey: Keys.breakEndTime) as? Date,
              endTime >= .now else {
            userDefaults?.removeObject(forKey: Keys.breakEndTime)
            return nil
        }
        return endTime
    }

    // 휴식 종료시간 삭제
    public func delete() {
        userDefaults?.removeObject(forKey: Keys.breakEndTime)
    }
}
