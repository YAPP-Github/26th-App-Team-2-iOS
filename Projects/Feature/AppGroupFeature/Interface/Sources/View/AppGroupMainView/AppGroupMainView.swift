//
//  AppGroupMainView.swift
//  FeatureAppGroupFeature
//
//  Created by Greem on 7/27/25.
//

import SwiftUI
import Domain
import SharedDesignSystem


public struct AppGroupMainView: View {
    
    @Environment(AppGroupMainViewModel.self) var appGroupMainViewModel
    @State var addGroupPresent = false
    public init() { }
    
    public var body: some View {
        ZStack {
            Color.grey900.ignoresSafeArea(.all)
            @Bindable var viewModel = appGroupMainViewModel
            if appGroupMainViewModel.appGroups.isEmpty {
                AppGroupMainEmptyAppGroupView {
                    appGroupMainViewModel.addButtonTapped()
                }
                .fullScreenCover(
                    isPresented: $viewModel.addGroupPresent
                ) {
                    AddAppGroupView()
                        .environment(
                            UpsertAppGroupViewModel(
                                createAppGroupUseCase: CreateAppGroupUseCase(),
                                createCompletion: { appGroup in
                                    self.appGroupMainViewModel.upsertCompleted(appGroup: appGroup)
                                }
                            )
                        )
                }
            } else {
                AppGroupMainGroupListView()
                    .fullScreenCover(
                        item: $viewModel.editAppGroup,
                        content: { appGroup in
                            AddAppGroupView()
                                .environment(
                                    UpsertAppGroupViewModel(
                                        appGroup: appGroup,
                                        createAppGroupUseCase: CreateAppGroupUseCase(),
                                        createCompletion: { appGroup in
                                            self.appGroupMainViewModel.upsertCompleted(appGroup: appGroup)
                                        }
                                    )
                                )
                        })
            }
        }
        .onAppear() {
            appGroupMainViewModel.onAppear()
        }
    }
}
