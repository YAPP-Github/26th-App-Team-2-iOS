//
//  BlockTime.swift
//  CoreAppScreenTime
//
//  Created by Derrick kim on 7/23/25.
//

import Foundation

public struct BlockTime: Codable {
    // 시간
    public let hour: Int
    // 분
    public let minute: Int

    public init(hour: Int, minute: Int) {
        self.hour = hour
        self.minute = minute
    }

    // 스타 생성 및 수정 모달을 통한 입력을 고려한 생성자
    public init(date: Date) {
        let starTime = TimeParser.extractTime(from: date)
        self.hour = starTime.hour
        self.minute = starTime.minute
    }

    // HH:mm 문자열을 통한 생성자
    public init(from description: String) {
        let starTime = TimeParser.parseTime(from: description)
        self.hour = starTime.hour
        self.minute = starTime.minute
    }

    // "HH:mm" 문자열
    public func time() -> String {
        let hour = String(format: "%02d", self.hour)
        let minute = String(format: "%02d", self.minute)
        return String(format: "%@:%@", hour, minute)
    }
    
    // 표시용 시간 문자열 (예: "오전 9:00", "오후 2:30")
    public var displayTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h:mm"
        
        // 현재 날짜를 기준으로 시간만 설정
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        
        if let date = Calendar.current.date(from: components) {
            return formatter.string(from: date)
        }
        
        // 폴백: 기본 형식
        return time()
    }

}

extension BlockTime: Comparable {
    // 비교 연산 로직
    public static func < (lhs: BlockTime, rhs: BlockTime) -> Bool {
        lhs.time() < rhs.time()
    }
}
