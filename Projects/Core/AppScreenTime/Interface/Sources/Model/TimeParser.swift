//
//  TimeParser.swift
//  CoreAppScreenTime
//
//  Created by Derrick kim on 7/23/25.
//

import Foundation

struct TimeParser {
    // "HH:mm" 문자열 -> (hour: Int, minute: Int) : 시간 문자열을 받아서 시와 분을 반환
    static func parseTime(from timeString: String) -> (hour: Int, minute: Int) {
        let components = timeString
            .components(separatedBy: ":")
            .compactMap { Int($0) }

        guard components.count == 2 else {
            return (hour: 0, minute: 0)
        }

        let hour = components[0]
        let minute = components[1]
        
        let isValidHour = (0...23).contains(hour)
        let isValidMinute = (0...59).contains(minute)

        guard isValidHour && isValidMinute else {
            return (hour: 0, minute: 0)
        }

        return (hour: hour, minute: minute)
    }

    // Date -> (hour: Int, minute: Int) : 현재 시간에서 시와 분을 추출하여 반환
    static func extractTime(from date: Date) -> (hour: Int, minute: Int) {
        let hour = Calendar.current.component(.hour, from: date)
        let minute = Calendar.current.component(.minute, from: date)
        let validHour = (0...23).contains(hour) ? hour : 0
        let validMinute = (0...59).contains(minute) ? minute : 0
        return (hour: validHour, minute: validMinute)
    }

    // (hour: Int, minute: Int) -> 유효한 시간과 분인지 검증하여 반환
    static func validateTime(hour: Int, minute: Int) -> (hour: Int, minute: Int) {
        let validHour = (0...23).contains(hour) ? hour : 0
        let validMinute = (0...59).contains(minute) ? minute : 0
        return (hour: validHour, minute: validMinute)
    }
}
