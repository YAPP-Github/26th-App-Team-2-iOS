//
//  OnboardingView.swift
//  FeatureOnboardingInterface
//
//  Created by Greem on 7/26/25.
//

import SwiftUI

public struct OnboardingView: View {
    
    @Environment(\.diContainer) var diContainer
    @Environment(StartUpViewModel.self) var startUpViewModel
    @State var onboardingManager = OnboardingManager()
    
    public init() { }
    
    public var body: some View {
        NavigationStack(path: $onboardingManager.path) {
            SetNickNameView()
                .environment(
                    SetNickNameViewModel(
                        userNickNameCreated: { nickName in
                            onboardingManager.nickName = nickName
                            onboardingManager.goToOnboardingInfo()
                        }
                    )
                )
                .navigationDestination(for: OnboardingViewType.self) { onboardingViewType in
                    switch onboardingViewType {
                    case .setNickName:
                        SetNickNameView()
                            .environment(
                                SetNickNameViewModel(
                                    userNickNameCreated: { nickName in
                                        onboardingManager.nickName = nickName
                                        onboardingManager.goToOnboardingInfo()
                                    }
                                )
                            )
                    case .onboardingInfo:
                        OnboardingInfoView(infoCompleted: {
                            onboardingManager.goToScreenTimeAuth()
                        })
                    case .screenTimeAuth:
                        ScreenTimeAuthView()
                            .environment(
                                ScreenTimeAuthViewModel(
                                    requestScreenTimeAuthUseCase: diContainer.requestScreenTimeAuthUseCase,
                                    screenTimeApproved: {
                                        onboardingManager.goToUserNotificationAuth()
                                    }
                                )
                            )
                    case .userNotificationAuth:
                        UserNotificationAuthView()
                            .environment(
                                UserNotificationAuthViewModel(
                                    requestUserNotificationAuthUseCase: diContainer.requestUserNotificationAuthUseCase,
                                    notificationApproved: {
                                        onboardingManager.goToOnboardingCompleted()
                                    }
                                )
                        )
                    case .onboardingCompleted(let nickName):
                        OnboardingCompletedView()
                            .environment(
                                OnboardingCompletedViewModel(
                                    userName: nickName,
                                    userSetNickNameUseCase: diContainer.userSetNickNameUseCase,
                                    onboardingCompleted: {
                                        startUpViewModel.onboardingCompleted()
                                    }
                                )
                        )
                            
                    }
                }
        }
        .environment(onboardingManager)
        .environment(startUpViewModel)
    }
}


enum OnboardingViewType: Hashable {
    case setNickName
    case onboardingInfo
    case screenTimeAuth
    case userNotificationAuth
    case onboardingCompleted(nickName: String)
}

@Observable
public final class OnboardingManager {
    @ObservationIgnored var nickName: String = ""
    var path: [OnboardingViewType] = []
    
    public init() {
        
    }
    
    public func goToOnboardingInfo() {
        path.append(.onboardingInfo)
    }
    
    public func goToScreenTimeAuth() {
        path.append(.screenTimeAuth)
    }
    
    public func goToUserNotificationAuth() {
        path.append(.userNotificationAuth)
    }
    
    public func goToOnboardingCompleted() {
        path.append(.onboardingCompleted(nickName: self.nickName))
    }
}
