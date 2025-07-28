//
//  AppGroupMainView.swift
//  FeatureAppGroupFeature
//
//  Created by Greem on 7/27/25.
//

import SwiftUI
import Domain

@Observable
public final class AppGroupMainViewModel {
    var addGroupPresent: Bool = false
    
    public init() {
        
    }
    
    public func addButtonTapped() {
        addGroupPresent.toggle()
    }
}

public struct AppGroupMainView: View {
    
    @Environment(AppGroupMainViewModel.self) var appGroupMainViewModel
    @State var addGroupPresent = false
    public init() { }
    
    public var body: some View {
        VStack {
            Button {
                appGroupMainViewModel.addButtonTapped()
            } label: {
                Text("추가")
            }
        }
        .fullScreenCover(
            isPresented:
                Binding(
                get: { appGroupMainViewModel.addGroupPresent },
                set: { appGroupMainViewModel.addGroupPresent = $0 }
            )
        ) {
            NavigationStack {
                AddAppGroupView()
                    .environment(
                        AddAppGroupViewModel(
//                            createAppGroupUseCase: CreateAppGroupUseCase()
                        )
                    )
            }
        }
    }
}
