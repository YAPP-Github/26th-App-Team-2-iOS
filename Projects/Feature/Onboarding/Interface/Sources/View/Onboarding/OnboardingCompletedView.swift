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
        VStack {
            Spacer()
            Button {
                viewModel.startBtnTapped()
            } label: {
                Text("시작하기")
            }
        }
    }
}
