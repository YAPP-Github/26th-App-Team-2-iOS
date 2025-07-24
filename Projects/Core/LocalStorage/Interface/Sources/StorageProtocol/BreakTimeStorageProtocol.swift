//
//  BreakTimeStorageProtocol.swift
//  CoreLocalStorage
//
//  Created by Derrick kim on 7/24/25.
//

import Foundation

public protocol BreakTimeStorageProtocol {
    func saveEndTime(_ minutes: Int)
    func getEndTime() -> Date?
    func delete()
}
