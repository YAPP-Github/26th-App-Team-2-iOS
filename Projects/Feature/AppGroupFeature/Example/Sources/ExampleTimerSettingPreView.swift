//
//  ExampleTimerSettingPreView.swift
//  FeatureAppGroupFeatureInterface
//
//  Created by Greem on 8/22/25.
//

import Foundation
import SwiftUI
import FeatureAppGroupFeatureInterface

struct TimeSettingPreView: View {
    @State private var showSheet: Bool = false
    @Environment(\.appGroupDIContainer) var diContainer
    @Environment(AppGroupMainViewModel.self) var viewModel
    var body: some View {
        Button {
            showSheet.toggle()
        } label: {
            Text("시트 띄우기")
        }.fullScreenCover(isPresented: $showSheet) {
            AppBrakeTimeSettingView()
                .environment(
                    AppBrakeTimeSettingViewModel(
                        createBreakTimeUseCase: diContainer.createBreakTimeUseCase,
                        setSelectedNotificationUseCase: diContainer.setSelectedNotificationUseCase,
                        createBreakTimeCompletion: { selectedTime in
                            viewModel.sessionTimerSettingCompletion(selectedTime: selectedTime)
                        }
                    )
                )
        }
    }
}
