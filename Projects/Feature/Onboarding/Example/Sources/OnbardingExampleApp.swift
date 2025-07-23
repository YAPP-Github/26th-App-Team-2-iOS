//
//  OnbardingExampleApp.swift
//  FeatureOnboarding
//
//  Created by Greem on 7/22/25.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import FeatureOnboardingInterface
import DomainOAuthInterface
import SharedUtil
import Domain

@main
struct OnbardingExampleApp: App {
    
    init() {
        guard let kakaoNativeAppKey: String = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String else {
            fatalError("네이티브 키 가져오기 실패")
        }
        KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environment(
                    LogInViewModel(
                        appleLogInUseCase: OAuthLogInUseCase(oAuthService: AppleLogInService.make()),
                        kakaoLogInUseCase: OAuthLogInUseCase(oAuthService: KakaoLogInService.make())
                    )
                )
                .onOpenURL { @MainActor url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
        }
    }
}
