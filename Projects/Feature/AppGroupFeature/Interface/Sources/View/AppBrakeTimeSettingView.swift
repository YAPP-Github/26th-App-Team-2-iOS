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

            VStack(spacing: 16) {
                // 제목
                VStack(spacing: 8) {
                    Text("\(viewModel.selectedAppName)을")
                        .font(.pretendard(size: 24, type: .semiBold))
                        .foregroundColor(.grey100)

                    Text("얼마나 사용할까요?")
                        .font(.pretendard(size: 24, type: .bold))
                        .foregroundColor(.brakeWhite)
                }
                .padding(.top, 78)
                
                Spacer()

                VStack(alignment: .center, spacing: 8) {
                    VStack(spacing: 10) {
                        Text("\(viewModel.getUpperFarNumber())")
                            .font(.pretendard(size: 20, type: .semiBold))
                            .foregroundColor(.grey600)
                        Text("\(viewModel.getUpperNearNumber())")
                            .font(.pretendard(size: 36, type: .semiBold))
                            .foregroundColor(.grey400)
                    }
                    .frame(height: 60)
                    
                    timeSelectionView

                    VStack(alignment: .center, spacing: 10) {
                        Text(viewModel.getLowerNearNumber())
                            .font(.pretendard(size: 36, type: .semiBold))
                            .foregroundColor(.grey400)
                        Text(viewModel.getLowerFarNumber())
                            .font(.pretendard(size: 20, type: .semiBold))
                            .foregroundColor(.grey600)
                    }
                }
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture()
                        .updating($dragState) { value, state, _ in
                            state = value.translation
                            handleDragUpdate(value: value)
                        }
                        .onEnded { value in
                            handleSwipe(value: value)
                        }
                )
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
                }
            }
            .padding(.bottom, 10)
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

fileprivate extension AppBrakeTimeSettingView {
    
    @ViewBuilder var timeSelectionView: some View {
        ZStack {
            // 배경
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.grey850)
                .frame(height: 133)
            VStack(alignment: .center, spacing: 16) {
                HStack(spacing: 4) {
                    ZStack {
                        Color.grey900
                            .frame(width: 98, height: 70)
                            .clipShape(RoundedRectangle(cornerRadius: 16))

                        Text("\(viewModel.selectedMinutes)")
                            .font(.pretendard(size: 55, type: .semiBold))
                            .foregroundColor(.brakeWhite)
                    }
                    Text("분")
                        .font(.pretendard(size: 16, type: .regular))
                        .foregroundColor(.grey50)
                        .offset(y: 9)
                }
                .offset(x: 5)
                .padding(.top, 6)

                // 예상 종료 시간
                Text("\(viewModel.endTime)까지")
                    .font(.pretendard(size: 16, type: .regular))
                    .foregroundColor(.grey300)
                    .offset(y: -2)
            }
        }
    }
    
    private func handleDragUpdate(value: DragGesture.Value) {
        let threshold: CGFloat = 80
        let currentIndex = viewModel.timeOptions.firstIndex(of: viewModel.selectedMinutes) ?? 0

        // 위로 드래그 (이전 값)
        if value.translation.height > threshold && currentIndex > 0 {
            withAnimation(.easeInOut(duration: 0.3)) {
                viewModel.updateSelectedTime(to: currentIndex - 1)
            }
        }
        // 아래로 드래그 (다음 값)
        else if value.translation.height < -threshold && currentIndex < viewModel.timeOptions.count - 1 {
            withAnimation(.easeInOut(duration: 0.3)) {
                viewModel.updateSelectedTime(to: currentIndex + 1)
            }
        }
    }

    private func handleSwipe(value: DragGesture.Value) {
        let threshold: CGFloat = 50
        let currentIndex = viewModel.timeOptions.firstIndex(of: viewModel.selectedMinutes) ?? 0

        // 위로 스와이프 (이전 값)
        if value.translation.height > threshold && currentIndex > 0 {
            withAnimation(.easeInOut(duration: 0.2)) {
                viewModel.updateSelectedTime(to: currentIndex - 1)
            }
        }
        // 아래로 스와이프 (다음 값)
        else if value.translation.height < -threshold && currentIndex < viewModel.timeOptions.count - 1 {
            withAnimation(.easeInOut(duration: 0.2)) {
                viewModel.updateSelectedTime(to: currentIndex + 1)
            }
        }
    }
}
