//
//  AppGroup.swift
//  DomainShared
//
//  Created by Greem on 7/28/25.
//

import Foundation
import FamilyControls
import Core

public struct AppGroup {
    public let name: String
    public let groupID: Int
    public let selection: FamilyActivitySelection
    
    public init(name: String, groupID: Int, selection: FamilyActivitySelection) {
        self.name = name
        self.groupID = groupID
        self.selection = selection
    }
}



public extension AppGroupEntity {
    convenience init(appGroup: AppGroup) throws {
        let selectionData = try JSONEncoder().encode(appGroup.selection)
        self.init(groupID: appGroup.groupID, name: appGroup.name, selectionData: selectionData)
    }
    
    func toAppGroup() throws -> AppGroup {
        let selectionData = try JSONDecoder().decode(
            FamilyActivitySelection.self,
            from: selectionData
        )
        return AppGroup(
            name: name,
            groupID: groupID,
            selection: selectionData
        )
    }
}
