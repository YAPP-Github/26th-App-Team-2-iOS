//
//  MainAuthModifier.swift
//  Brake
//
//  Created by Greem on 8/12/25.
//

import Foundation
import SwiftUI
import Feature

struct MainAuthModifier: ViewModifier {
    @Environment(\.appDIContainer) private var appDIContainer
    @Environment(MainAppViewModel.self) private var mainAppViewModel
    func body(content: Content) -> some View {
        @Bindable var viewModel = mainAppViewModel
        content.fullScreenCover(item: $viewModel.authFailedPresented) { item in
            switch item {
            case .both:
                BothAuthViewModel()
                    .environment(mainAppViewModel)
            case .notification:
                MainUserNotificationAuthView(showNavigation: false)
                    .environment(mainAppViewModel)
                    .environment(
                        UserNotificationAuthViewModel(
                            requestUserNotificationAuthUseCase: appDIContainer.useCaseContainer.requestUserNotificationAuthUseCase,
                            notificationApproved: {
                                mainAppViewModel.authFailedPresented = nil
                            }
                        )
                    )
            case .screenTime:
                MainScreenTimeAuthView(showNavigation: false)
                    .environment(mainAppViewModel)
                    .environment(
                        ScreenTimeAuthViewModel(
                            requestScreenTimeAuthUseCase: appDIContainer.useCaseContainer.requestScreenTimeAuthUseCase,
                            screenTimeApproved: {
                                mainAppViewModel.authFailedPresented = nil
                            }
                        )
                    )
            }
        }
    }
    
    struct BothAuthViewModel: View {
        @Environment(MainAppViewModel.self) var mainAppViewModel
        @Environment(\.appDIContainer) private var appDIContainer
        @State private var showNotificationAuth: Bool = false
        var body: some View {
            NavigationStack {
                MainScreenTimeAuthView(showNavigation: false)
                    .navigationDestination(isPresented: $showNotificationAuth, destination: {
                        MainUserNotificationAuthView(showNavigation: true)
                            .environment(mainAppViewModel)
                            .environment(
                                UserNotificationAuthViewModel(
                                    requestUserNotificationAuthUseCase: appDIContainer.useCaseContainer.requestUserNotificationAuthUseCase,
                                    notificationApproved: {
                                        mainAppViewModel.authFailedPresented = nil
                                    }
                                )
                            )
                    })
                    .environment(mainAppViewModel)
                    .environment(
                        ScreenTimeAuthViewModel(
                            requestScreenTimeAuthUseCase: appDIContainer.useCaseContainer.requestScreenTimeAuthUseCase,
                            screenTimeApproved: {
                                Task { @MainActor in
                                    showNotificationAuth = true
                                }
                            }
                        )
                    )
                    
            }
        }
    }
    
    struct MainUserNotificationAuthView: View {
        @Environment(MainAppViewModel.self) var mainAppViewModel
        @Environment(UserNotificationAuthViewModel.self) var userNotificationAuthViewModel
        @Environment(\.dismiss) var dismiss
        let showNavigation: Bool
        var body: some View {
            @Bindable var viewModel = userNotificationAuthViewModel
            UserNoficationAuth(
                showNaivgation: showNavigation,
                authorizationButtonAction: {
                    viewModel.authorizationButtonTapped()
                },
                notoficationAuthFailedResult: userNotificationAuthViewModel.notoficationAuthFailedResult,
                notificationAuthDeniedPresent: $viewModel.notificationAuthDeniedPresent,
                notificationAuthFailedPresent: $viewModel.notificationAuthFailedPresent
            )
        }
    }

    struct MainScreenTimeAuthView: View {
        @Environment(MainAppViewModel.self) private var mainAppViewModel
        @Environment(ScreenTimeAuthViewModel.self) private var userNotificationAuthViewModel
        @Environment(\.dismiss) private var dismiss
        let showNavigation: Bool
        var body: some View {
            @Bindable var viewModel = userNotificationAuthViewModel
            ScreenTimeAuth(
                showNavigation: showNavigation,
                authorizationButtonAction: {
                    viewModel.authorizationButtonTapped()
                },
                screenTimeAuthFailedResult: userNotificationAuthViewModel.screenTimeAuthFailedResult,
                cancelScreenTimeGrantPresented: $viewModel.cancelScreenTimeGrantPresented,
                screenTimeAuthFailedPresent: $viewModel.screenTimeAuthFailedPresent
            )
        }
    }
}
