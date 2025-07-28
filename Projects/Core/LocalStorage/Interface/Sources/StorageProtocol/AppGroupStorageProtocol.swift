//
//  AppGroupStorageProtocol.swift
//  CoreLocalStorageInterface
//
//  Created by Greem on 7/28/25.
//

import Foundation
import SwiftData

public protocol AppGroupStorageProtocol {
    var context: ModelContext { get }
    func getAllAppGroupEntities() async throws -> [AppGroupEntity]
    func getAppGroupEntity(groupID: Int) async throws -> AppGroupEntity
    
    func appendAppGroupEntity(_ appGroup: AppGroupEntity) async throws
    func upsertAppGroupEntity(_ appGroup: AppGroupEntity) async throws
    
    func deleteAppGroupEntity(groupID: Int) async throws
}


public final actor AppGroupStorage {
    
    public let context: ModelContext
    
    public init() {
        do {
            let container = try ModelContainer(for: AppGroupEntity.self)
            self.context = ModelContext(container)
        } catch {
            fatalError("컨테이너 생성 문제 \(error.localizedDescription)")
        }
    }
}
