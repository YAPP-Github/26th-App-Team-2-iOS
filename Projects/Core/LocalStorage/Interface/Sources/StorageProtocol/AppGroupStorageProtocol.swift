//
//  AppGroupStorageProtocol.swift
//  CoreLocalStorageInterface
//
//  Created by Greem on 7/28/25.
//

import Foundation


public protocol AppGroupStorageProtocol {
    func getAllGroups() throws -> [AppGroup]
    func getGroup(id: Int) throws -> AppGroup
    func appendGroup(_ appGroup: AppGroup) throws
    func upsertGroup(_ appGroup: AppGroup) throws
    func deleteGroup(id: Int) throws
}
