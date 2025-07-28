//
//  AppGroupStorageMock.swift
//  CoreLocalStorageTesting
//
//  Created by Greem on 7/28/25.
//

import Foundation
import SwiftData
import CoreLocalStorageInterface
import CoreLocalStorage


public final actor MockAppGroupStorage: @preconcurrency AppGroupStorageProtocol {
    public let context: ModelContext
    public init() {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: AppGroupEntity.self, configurations: config)
            self.context = ModelContext(container)
        } catch {
            fatalError("컨테이너 생성 에러: \(error.localizedDescription)")
        }
    }
}
