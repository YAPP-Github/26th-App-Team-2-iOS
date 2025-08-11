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
                    bottomPadding: 60
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

fileprivate extension ScreenTimeAuthorizationResult {
    var title: String {
        switch self {
        case .denied: "스크린타임 권한이 거부되었습니다"
        case .restricted: "스크린타임 기능이 제한되었습니다"
        case .unavailableDevice: "지원하지 않는 기기입니다"
        case .userCancel: "스크린타임 권한이 필요합니다"
        case .approved: ""
        case .unknownError, .authenticationMethodUnavailable: "인증 중 오류가 발생했습니다"
        case .networkError: "네트워크 연결을 확인해주세요"
        }
    }
    var desc: String {
        switch self {
        case .denied: "설정에서 스크린타임 권한을 허용해주세요"
        case .restricted: "부모님의 허가가 필요합니다"
        case .unavailableDevice: "이 기기에서는 스크린타임 기능을 사용할 수 없습니다"
        case .userCancel: "앱 사용 제한 기능을 사용하려면 권한이 필요합니다"
        case .approved: ""
        case .unknownError, .authenticationMethodUnavailable, .networkError: "잠시 후 다시 시도해주세요"
        }
    }
    
    var primaryButtonTitle: String {
        switch self {
        case .denied, .unknownError, .userCancel, .approved, .authenticationMethodUnavailable, .networkError: "다시 시도하기"
        case .restricted, .unavailableDevice: "확인"
        }
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
