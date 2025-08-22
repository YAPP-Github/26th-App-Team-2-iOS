//
//  AppBrakeTimeSettingView.swift
//  FeatureAppGroupFeatureInterface
//
//  Created by Derrick kim on 2025/08/03.
//

import SwiftUI
import SharedDesignSystem
import Domain

public struct AppBrakeTimeSettingView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(AppBrakeTimeSettingViewModel.self) private var viewModel
    @GestureState private var dragState: CGSize = .zero
    
    public init() {}

    public var body: some View {
        ZStack {
            Color.grey900.ignoresSafeArea()
            VStack(spacing: 0) {
                BrakeNavigationView(title: {
                    EmptyView()
                }, trailing: {
                    BrakeNavigationButton(type: .cancel) {
                        dismiss()
                    }
                })
                // 제목
                Text("얼마나 사용할까요?")
                    .font(.pretendard(size: 24, type: .bold))
                    .foregroundColor(.brakeWhite)
                    .padding(.top, 78)

                Spacer()

                // 완료 버튼
                Button(action: {
                    viewModel.brakeTimeSettingCompleteButtonTapped()
                }) {
                    Text("완료")
                        .font(.pretendard(size: 16, type: .semiBold))
                        .foregroundColor(.grey900)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Color.brakeYellow)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }.padding(.horizontal, 16)
            }
            .padding(.bottom, 10)
            
            BrakeTimeWheelPickerView()
                .padding(.horizontal, 16)
        }
        .overlay {
            if viewModel.brakeTimeSettingCompletePresent {
                CompleteTimeSettingView(selectedMinutes: viewModel.selectedMinutes, endTime: viewModel.endTime)
                    .transition(.opacity)
                    .animation(
                        .easeInOut(duration: 0.3),
                        value: viewModel.brakeTimeSettingCompletePresent
                    )
            }
        }
        .onChange(of: viewModel.dismiss) { oldValue, newValue in
            if newValue {
                self.dismiss()
            }
        }
    }
}
