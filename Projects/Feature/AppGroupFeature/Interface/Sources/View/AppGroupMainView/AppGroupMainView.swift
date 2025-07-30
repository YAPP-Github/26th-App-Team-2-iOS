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
                .toast(
                    message: appGroupMainViewModel.toastMessage,
                    bottomPadding: 60
                )
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
            }
        }
        .brakePopUp(
            isPresented: Binding(
                get: { appGroupMainViewModel.screenTimeAuthAlertPresent } ,
                set: { appGroupMainViewModel.screenTimeAuthAlertPresent = $0 }
            ),
            title: appGroupMainViewModel.screenTimeAuthErrorResult?.title ?? "",
            message: appGroupMainViewModel.screenTimeAuthErrorResult?.desc,
            primaryButtonTitle: appGroupMainViewModel.screenTimeAuthErrorResult?.primaryButtonTitle ?? "",
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
                self.appGroupMainViewModel.onAppear()
            }
        })
        .onAppear() {
            appGroupMainViewModel.onAppear()
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
