//
//  ScreenTimeAuthView.swift
//  FeatureOnboardingInterface
//
//  Created by Greem on 7/25/25.
//

import SwiftUI
import Domain
import SharedDesignSystem

public struct ScreenTimeAuthView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(StartUpViewModel.self) private var startUpViewModel
    @Environment(ScreenTimeAuthViewModel.self) private var screenTimeAuthViewModel
    
    
    public init() { }
    
    public var body: some View {
        @Bindable var viewModel = screenTimeAuthViewModel
        ZStack(alignment: .bottom) {
            Color.grey900.ignoresSafeArea()
            VStack(spacing: 0) {
                BrakeNavigationView(title: {
                    EmptyView()
                }, leading: {
                    BrakeNavigationButton(type: .back) {
                        dismiss()
                    }
                })
                VStack(alignment: .center, spacing: 16) {
                    VStack(alignment: .center, spacing: 0) {
                        Text("스크린 타임 권한을").frame(height: 33)
                        Text("허용해주세요.").frame(height: 33)
                    }
                    .foregroundStyle(.white)
                    .font(.pretendard(size: 22, type: .semiBold))
                    Text("앱 사용량을 모니터링해요.")
                        .foregroundStyle(Color.grey200)
                        .font(.pretendard(size: 16, type: .medium))
                }
                .padding(.top, 47)
                Spacer()
            }
            
            GeometryReader { proxy in
                ZStack {
                    Color.clear
                    Image.onboarding.screentime
                        .resizable()
                        .frame(width: proxy.size.width * 0.688)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            LargeButtonView(
                buttonType: .confirm,
                title: "허용하기",
                isActive: true
            ) {
                screenTimeAuthViewModel.authorizationButtonTapped()
            }
            .padding(.bottom, 16)
        }
        .toolbar(.hidden, for: .navigationBar)
        .brakePopUp(
            isPresented: $viewModel.cancelScreenTimeGrantPresented,
            title: "스크린타임 권한이 필요해요",
            message: "Brake!의 기능을 사용하기 위해서는\n스크린타임 연동이 필수적이에요.",
            icon: .iconConfetti,
            primaryButtonTitle: "확인",
            primaryBackgroundColor: .brakeYellow,
            primaryAction: {
                viewModel.cancelScreenTimeGrantPresented = false
            }
        )
        .brakePopUp(
            isPresented: $viewModel.screenTimeAuthFailedPresent,
            title: viewModel.screenTimeAuthFailedResult?.alertTitle ?? "",
            message: viewModel.screenTimeAuthFailedResult?.alertDescription ?? "",
            icon: .iconConfetti,
            primaryButtonTitle: "확인",
            primaryBackgroundColor: .brakeYellow,
            primaryAction: {
                viewModel.screenTimeAuthFailedPresent = false
            }
        )
    }
}
