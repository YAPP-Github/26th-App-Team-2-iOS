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

// MARK: - Custom Environment Key

public struct AppGroupMainView: View {
    @Environment(\.appGroupDIContainer) private var diContainer
    @Environment(AppGroupMainViewModel.self) private var appGroupMainViewModel
    @Environment(\.scenePhase) var scenePhase
    
    public init() { }
    public var body: some View {
        NavigationStack {
            @Bindable var viewModel: AppGroupMainViewModel = appGroupMainViewModel
            ZStack {
                Color.grey900.ignoresSafeArea()
                // 두 뷰를 모두 렌더링하되 opacity로 부드럽게 전환
                Group {
                    if viewModel.appGroups.isEmpty {
                        AppGroupMainEmptyAppGroupView {
                            appGroupMainViewModel.addButtonTapped()
                        }
                    } else {
                        AppGroupMainGroupListView()
                    }
                }
                .brakePopUp(
                    isPresented: $viewModel.sessionExitAlertPresent,
                    title: "앱 사용을 종료할까요?",
                    message: "예정보다 일찍 마무리하셨네요. 멋진 선택이에요!",
                    icon: Image.iconConfetti,
                    primaryButtonTitle: "종료하기",
                    primaryBackgroundColor: Color.buttonYellow,
                    showCloseButton: true,
                    primaryAction: {
                        viewModel.sessionExitConfirmBtnTapped()
                    }, closeAction: {
                        viewModel.sessionExitAlertPresent = false
                    }
                )
                .toast(
                    message: appGroupMainViewModel.toastMessage,
                    bottomPadding: 0
                )
                .fullScreenCover(
                    isPresented: $viewModel.appBrakeTimeSettingPresent,
                    content: {
                        AppBrakeTimeSettingView()
                            .environment(
                                AppBrakeTimeSettingViewModel(
                                    createBreakTimeUseCase: diContainer.createBreakTimeUseCase,
                                    fetchAppNameUseCase: diContainer.fetchAppNameUseCase,
                                    createBreakTimeCompletion: { selectedTime in
                                        viewModel.sessionTimerSettingCompletion(selectedTime: selectedTime)
                                    }
                                )
                            )
                    }
                )
                .fullScreenCover(isPresented: $viewModel.addGroupPresent) {
                    UpsertAppGroupView()
                        .environment(createUpsertAppGroupViewModel())
                }
                .fullScreenCover(
                    item: $viewModel.editAppGroup,
                    content: { appGroup in
                        UpsertAppGroupView()
                            .environment(updateUpsertAppGroupViewModel(appGroup: appGroup))
                    }
                )
            }
            
        }
        .onChange(of: scenePhase, { oldValue, newValue in
            switch newValue {
            case .inactive: self.appGroupMainViewModel.setScene(.inActive)
            case .active: self.appGroupMainViewModel.setScene(.active)
            case .background: self.appGroupMainViewModel.setScene(.background)
            @unknown default:
                assertionFailure("알 수 없는 타입 발생")
                self.appGroupMainViewModel.setScene(.background)
            }
        })
        .onAppear() { appGroupMainViewModel.onAppear() }
        .onDisappear() { appGroupMainViewModel.onDisAppear() }
    }
}


fileprivate extension AppGroupMainView {
    func createUpsertAppGroupViewModel() -> UpsertAppGroupViewModel {
        UpsertAppGroupViewModel(
            upsertAppGroupUseCase: diContainer.upsertAppGroupUseCase,
            upsertCompletion: { appGroup in
                self.appGroupMainViewModel.upsertCompleted(appGroup: appGroup)
            }
        )
    }
    
    func updateUpsertAppGroupViewModel(appGroup: AppGroup) -> UpsertAppGroupViewModel {
        UpsertAppGroupViewModel(
            appGroup: appGroup,
            upsertAppGroupUseCase: diContainer.upsertAppGroupUseCase,
            upsertCompletion: { appGroup in
                self.appGroupMainViewModel.upsertCompleted(appGroup: appGroup)
            },
            deleteAppGroupUseCase: diContainer.deleteAppGroupUseCase,
            deleteCompletion: { appGroup in
                self.appGroupMainViewModel.deleteCompleted(appGroup: appGroup)
            }
        )
    }
}
