//
//  AppGroupMainView.swift
//  FeatureAppGroupFeature
//
//  Created by Greem on 7/27/25.
//

import SwiftUI
import Domain
import SharedDesignSystem
import FamilyControls

extension Image: @retroactive AppGroupImagesProtocol { }

public struct AppGroupMainView: View {
    
    @Environment(AppGroupMainViewModel.self) var appGroupMainViewModel
    @State var addGroupPresent = false
    public init() { }
    
    public var body: some View {
        ZStack {
            Color.grey900.ignoresSafeArea()
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
                .toast(
                    message: appGroupMainViewModel.toastMessage,
                    bottomPadding: 60
                )
            .onAppear() {
                Task {
                    try await RequestScreenTimeAuthUseCase().execute()
                }
            }
            .fullScreenCover(
                isPresented: $viewModel.addGroupPresent
            ) {
                UpsertAppGroupView()
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
                    UpsertAppGroupView()
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
