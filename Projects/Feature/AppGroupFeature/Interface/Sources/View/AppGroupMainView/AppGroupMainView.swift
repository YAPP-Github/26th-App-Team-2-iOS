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
            Group {
                if appGroupMainViewModel.appGroups.isEmpty {
                    AppGroupMainEmptyAppGroupView {
                        appGroupMainViewModel.addButtonTapped()
                    }
                    
                } else {
                    AppGroupMainGroupListView()
                        
                }
            }
            .fullScreenCover(
                isPresented: $viewModel.addGroupPresent
            ) {
                AddAppGroupView()
                    .environment(
                        UpsertAppGroupViewModel(
                            upsertAppGroupUseCase: UpsertAppGroupUseCase(),
                            upsertCompletion: { appGroup in
                                self.appGroupMainViewModel.upsertCompleted(appGroup: appGroup)
                            }
                        )
                    )
            }
            .fullScreenCover(
                item: $viewModel.editAppGroup,
                content: { appGroup in
                    AddAppGroupView()
                        .environment(
                            UpsertAppGroupViewModel(
                                appGroup: appGroup,
                                upsertAppGroupUseCase: UpsertAppGroupUseCase(),
                                upsertCompletion: { appGroup in
                                    self.appGroupMainViewModel.upsertCompleted(appGroup: appGroup)
                                },
                                deleteAppGroupUseCase: DeleteAppGroupUseCase(),
                                deleteCompletion: { appGroup in
                                    self.appGroupMainViewModel.deleteCompleted(appGroup: appGroup)
                                }
                            )
                        )
                })
        }
        .onAppear() {
            appGroupMainViewModel.onAppear()
        }
    }
}
