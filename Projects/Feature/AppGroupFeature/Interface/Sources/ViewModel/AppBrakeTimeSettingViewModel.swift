//
//  AppBrakeTimeSettingViewModel.swift
//  FeatureAppGroupFeatureInterface
//
//  Created by Greem on 8/5/25.
//

import Foundation
import Domain

@Observable
public final class AppBrakeTimeSettingViewModel {
    public let timeOptions: [Int] = [5, 10, 15, 20, 25, 30, 45, 60, 90]
    var selectedMinutes: Int = 1
    var brakeTimeSettingCompletePresent: Bool = false
    var dismiss: Bool = false
    
    private let createBreakTimeCompletion: (Int) -> ()
    
    private let createBreakTimeUseCase: CreateBreakTimeUseCaseProtocol
    private let setSelectedNotificationUseCase: SetSelectedNotificationUseCaseProtocol

    public init(
        createBreakTimeUseCase: CreateBreakTimeUseCaseProtocol,
        setSelectedNotificationUseCase: SetSelectedNotificationUseCaseProtocol,
        createBreakTimeCompletion: @escaping (Int) -> ()
    ) {
        self.createBreakTimeUseCase = createBreakTimeUseCase
        self.setSelectedNotificationUseCase = setSelectedNotificationUseCase
        self.createBreakTimeCompletion = createBreakTimeCompletion
    }
    
    // MARK: - AppBrakeTimeSetting Logic
    public var endTime: String {
        let now = Date()
        let endDate = now.addingTimeInterval(TimeInterval(selectedMinutes * 60))

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h시 m분"

        return formatter.string(from: endDate)
    }

    @MainActor
    public func updateSelectedTime(to index: Int) {
        selectedMinutes = timeOptions[index]
    }
    
    public func brakeTimeSettingCompleteButtonTapped() {
        Task {
            do {
                try await createBreakTimeUseCase.execute(by: selectedMinutes)
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    brakeTimeSettingCompletePresent = true
                    createBreakTimeCompletion(selectedMinutes)
                }
                try await Task.sleep(for: .seconds(1))
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    dismiss = true
                }
            } catch {
                await MainActor.run {
                    print("휴게시간 설정에 실패했습니다")
                }
            }
        }
    }
    public func brakeTimeSettingCancelButtonTapped() {
        self.setSelectedNotificationUseCase.execute(false)
        dismiss = true
    }
}
