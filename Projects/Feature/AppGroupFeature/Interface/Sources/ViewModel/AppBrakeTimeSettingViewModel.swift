//
//  AppBrakeTimeSettingViewModel.swift
//  FeatureAppGroupFeatureInterface
//
//  Created by Greem on 8/5/25.
//

import Foundation
import Domain

@Observable
final class AppBrakeTimeSettingViewModel {
    public let timeOptions = [15, 20, 25, 30, 45, 60, 90, 120]
    var selectedMinutes: Int = 15
    var brakeTimeSettingCompletePresent: Bool = false
    var dismiss: Bool = false
    
    private let createBreakTimeCompletion: (Int) -> ()
    
    private let createBreakTimeUseCase: CreateBreakTimeUseCaseProtocol

    public init(
        createBreakTimeUseCase: CreateBreakTimeUseCaseProtocol,
        createBreakTimeCompletion: @escaping (Int) -> ()
    ) {
        self.createBreakTimeUseCase = createBreakTimeUseCase
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

    public func getUpperFarNumber() -> String {
        let currentIndex = timeOptions.firstIndex(of: selectedMinutes) ?? 0
        let targetIndex = currentIndex - 2

        // 범위를 벗어나면 빈 문자열 반환
        if targetIndex < 0 {
            return ""
        }

        let farNumber = timeOptions[targetIndex]
        let nearNumber = getUpperNearNumber()

        // near와 far 숫자가 같으면 빈 문자열 반환
        if nearNumber == "\(farNumber)" {
            return ""
        }

        return "\(farNumber)"
    }

    public func getUpperNearNumber() -> String {
        let currentIndex = timeOptions.firstIndex(of: selectedMinutes) ?? 0
        let targetIndex = currentIndex - 1

        // 범위를 벗어나면 빈 문자열 반환
        if targetIndex < 0 {
            return ""
        }
        return "\(timeOptions[targetIndex])"
    }

    public func getLowerNearNumber() -> String {
        let currentIndex = timeOptions.firstIndex(of: selectedMinutes) ?? 0
        let targetIndex = currentIndex + 1

        // 범위를 벗어나면 빈 문자열 반환
        if targetIndex >= timeOptions.count {
            return ""
        }
        return "\(timeOptions[targetIndex])"
    }

    public func getLowerFarNumber() -> String {
        let currentIndex = timeOptions.firstIndex(of: selectedMinutes) ?? 0
        let targetIndex = currentIndex + 2

        // 범위를 벗어나면 빈 문자열 반환
        if targetIndex >= timeOptions.count {
            return ""
        }

        let farNumber = timeOptions[targetIndex]
        let nearNumber = getLowerNearNumber()

        // near와 far 숫자가 같으면 빈 문자열 반환
        if nearNumber == "\(farNumber)" {
            return ""
        }

        return "\(farNumber)"
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
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    print("휴게시간 설정에 실패했습니다")
                }
            }
        }
    }
}
