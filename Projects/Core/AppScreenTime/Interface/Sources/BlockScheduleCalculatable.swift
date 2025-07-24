//
//  BlockScheduleCalculatorProtocol.swift
//  CoreAppScreenTime
//
//  Created by Derrick kim on 7/24/25.
//

import Foundation

public protocol BlockScheduleCalculatorProtocol {
    func calculate(
        with startTime: BlockTime,
        and endTime: BlockTime
    ) -> CalculatedBlockSchedule
}
