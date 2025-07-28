//
//  OnboardingCompletedView.swift
//  FeatureOnboardingInterface
//
//  Created by Greem on 7/26/25.
//

import SwiftUI

public struct OnboardingCompletedView: View {
    @Environment(StartUpViewModel.self) var startUpViewModel
    @Environment(OnboardingCompletedViewModel.self) var viewModel
    public init() { }
    public var body: some View {
        @Bindable var viewModel = viewModel
        VStack {
            Spacer()
            Button {
                viewModel.startBtnTapped()
            } label: {
                Text("시작하기")
            }
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
    }
}
