//
//  BreakTimeProtocol.swift
//  CoreAppScreenTime
//
//  Created by Derrick kim on 7/24/25.
//

import Foundation

public protocol BreakTimeProtocol {
    func createBreakTime(minutes: Int) throws
    
    func getStartDate() -> Date
    func getEndDate() -> Date
}
