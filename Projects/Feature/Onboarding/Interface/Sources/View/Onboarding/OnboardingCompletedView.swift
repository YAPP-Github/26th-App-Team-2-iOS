//
//  OnboardingCompletedView.swift
//  FeatureOnboardingInterface
//
//  Created by Greem on 7/26/25.
//

import SwiftUI
import SharedDesignSystem

public struct OnboardingCompletedView: View {
    @Environment(StartUpViewModel.self) var startUpViewModel
    @Environment(OnboardingCompletedViewModel.self) var viewModel
    public init() { }
    public var body: some View {
        ZStack(alignment: .bottom) {
            self.background
            @Bindable var viewModel = viewModel
            VStack(spacing: 0) {
                BrakeNavigationView(title: EmptyView()).background(.clear)
                VStack(spacing: 16) {
                    Text("반가워요!")
                        .font(.pretendard(size: 28, type: .bold))
                    Text("목표를 세우고 지키는\n새로운 일상을 경험해보세요")
                            .font(.pretendard(size: 20, type: .semiBold))
                            .lineSpacing(6)
                            .multilineTextAlignment(.center)
                }
                .foregroundStyle(.white)
                .padding(.top, 24)
                Spacer()
            }
            .alert(
                "알 수 없는 에러가 발생했습니다.",
                isPresented: $viewModel.errorOccuredPresented,
                actions: {
                    Button("확인", role: .cancel) { }
                },
                message: {
                    Text("다시 시도해주세요.")
                }
            )
            VStack {
                Spacer()
                Image.onboarding.coolDown
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .padding(.horizontal, 48)
                Spacer()
            }
        
            
            LargeButtonView(buttonType: .confirm, title: "시작하기", isActive: true) {
                viewModel.startBtnTapped()
            }
            .padding(.bottom, 16)
        }
        .toolbar(.hidden, for: .navigationBar)
    }
    
    @ViewBuilder var background: some View {
        Color.grey900.ignoresSafeArea()
        GeometryReader { proxy in
            LinearGradient(
                stops: [
                    .init(color: Color(red: 192 / 255, green: 219 / 255, blue: 255 / 255), location: 0),
                    .init(color: Color(red: 192 / 255, green: 219 / 255, blue: 255 / 255).opacity(0.28), location: 0.56),
                    .init(color: Color(red: 192 / 255, green: 219 / 255, blue: 255 / 255).opacity(0), location: 1)
                ],
                startPoint: .top,
                endPoint: .bottom
            ).opacity(0.15)
                .frame(height: proxy.size.height * 0.5)
        }
        .ignoresSafeArea(.all)
    }
}
