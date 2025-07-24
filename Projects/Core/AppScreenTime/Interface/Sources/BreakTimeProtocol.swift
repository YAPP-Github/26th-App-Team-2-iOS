//
//  BreakTimeProtocol.swift
//  CoreAppScreenTime
//
//  Created by Derrick kim on 7/24/25.
//

import Foundation

public protocol BreakTimeProtocol {
    func createBreakTime(endDate: Date?) throws
    func deleteBreakTime()
}
