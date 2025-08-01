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
            ZStack {
                Color.grey900.ignoresSafeArea()
                @Bindable var viewModel = appGroupMainViewModel
                
                // 두 뷰를 모두 렌더링하되 opacity로 부드럽게 전환
                Group {
                    if appGroupMainViewModel.appGroups.isEmpty {
                        AppGroupMainEmptyAppGroupView {
                            appGroupMainViewModel.addButtonTapped()
                        }
                    } else {
                        // Group List View
                        AppGroupMainGroupListView()
                    }
                }
                .alert(isPresented: $viewModel.sessionExitAlertPresent, content: {
                    SessionExitAlertView {
                        viewModel.sessionExitAlertPresent = false
                    } exitAction: {
                        viewModel.sessionExitConfirmBtnTapped()
                    }
                }, background: {
                    Color.black.opacity(0.5)
                })
                .alert(isPresented: $viewModel.sessionExitAlertPresent, content: {
                    SessionExitAlertView {
                        viewModel.sessionExitAlertPresent = false
                    } exitAction: {
                        viewModel.sessionExitConfirmBtnTapped()
                    }
                }, background: {
                    Color.black.opacity(0.5)
                })
                .toast(
                    message: appGroupMainViewModel.toastMessage,
                    bottomPadding: 60
                )
                .fullScreenCover(isPresented:  $viewModel.timerSettingPresent, content: {
                    TimerSettingView { selectedTime in
                        viewModel.sessionTimerSettingCompletion(selectedTime: selectedTime)
                    }
                })
                .fullScreenCover(
                    isPresented: $viewModel.addGroupPresent
                ) {
                    UpsertAppGroupView()
                        .environment(createUpsertAppGroupViewModel())
                }
                .fullScreenCover(
                    item: $viewModel.editAppGroup,
                    content: { appGroup in
                        UpsertAppGroupView()
                            .environment(updateUpsertAppGroupViewModel(appGroup: appGroup))
                    })
                .fullScreenCover(
                    isPresented: .init(get: {
                        viewModel.appBrakeTimeSettingPresent
                    }, set: { isPresented in
                        viewModel.appBrakeTimeSettingPresent = isPresented
                    })
                ) {
                    AppBrakeTimeSettingView()
                }
            }
        }
        .brakePopUp(
            isPresented: Binding(
                get: { appGroupMainViewModel.screenTimeAuthAlertPresent } ,
                set: { appGroupMainViewModel.screenTimeAuthAlertPresent = $0 }
            ),
            title: appGroupMainViewModel.screenTimeAuthErrorResult?.title ?? "스크린타임 권한 오류",
            message: appGroupMainViewModel.screenTimeAuthErrorResult?.desc ?? "스크린타임 권한 처리 중 알 수 없는 오류가 발생했습니다. 잠시 후 다시 시도해주세요.",
            primaryButtonTitle: appGroupMainViewModel.screenTimeAuthErrorResult?.primaryButtonTitle ?? "확인",
            primaryAction: {
                guard let result = appGroupMainViewModel.screenTimeAuthErrorResult else {
                    appGroupMainViewModel.screenTimeAuthAlertPresent = false
                    return
                }
                switch result {
                case .denied, .unknownError, .userCancel, .approved, .authenticationMethodUnavailable, .networkError:
                    appGroupMainViewModel.reAuthButtonTapped()
                case .restricted, .unavailableDevice: break
                }
            }
        )
        .onChange(of: scenePhase, { oldValue, newValue in
            if newValue == .active {
                self.appGroupMainViewModel.sceneActive()
            }
        })
        .onAppear() {
            appGroupMainViewModel.onAppear()
        }
    }
}


extension AppGroupMainView {
    struct SessionExitAlertView: View {
        let cancelAction: () -> ()
        let exitAction: () -> ()
        var body: some View {
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button {
                        cancelAction()
                    } label: {
                        Image.iconCancel
                    }
                }
                .padding(.bottom, 7)
                VStack(spacing: 8) {
                    Image.iconConfetti
                        .resizable()
                        .scaledToFit()
                        .frame(width: 110)
                        .padding(.bottom, 2)
                    Text("앱 사용을 종료할까요?")
                        .font(.pretendard(size: 22, type: .semiBold))
                        .foregroundStyle(Color.grey00)
                    Text("예정보다 일찍 마무리하셨네요.\n멋진 선택이에요!")
                        .font(.pretendard(size: 16, type: .medium))
                        .foregroundStyle(Color.grey200)
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, 42)
                LargeButtonView(buttonType: .confirm, title: "종료하기", isActive: true) {
                    exitAction()
                }
            }
            .padding(16)
            .background(Color.grey850)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 28)
        }
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
