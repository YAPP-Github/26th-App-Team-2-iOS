//
//  AppGroupMainViewModel.swift
//  FeatureAppGroupFeature
//
//  Created by Greem on 7/28/25.
//

import Foundation
import Domain

@Observable
public final class AppGroupMainViewModel {
    var addGroupPresent: Bool = false
    var appGroupName: String = ""
    var appGroups: [AppGroup] = []
    
    private let fetchAppGroupUseCase: FetchAppGroupUseCase
    public init(
        fetchAppGroupUseCase: FetchAppGroupUseCase
    ) {
        self.fetchAppGroupUseCase = fetchAppGroupUseCase
    }
    
    public func addButtonTapped() {
        addGroupPresent.toggle()
    }
}
