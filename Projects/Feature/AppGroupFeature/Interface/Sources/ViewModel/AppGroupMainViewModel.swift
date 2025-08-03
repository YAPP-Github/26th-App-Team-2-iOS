//
//  AppGroupMainViewModel.swift
//  FeatureAppGroupFeature
//
//  Created by Greem on 7/28/25.
//

import Foundation
import Domain

extension AppGroup: @retroactive Identifiable {
    public var id: Int { self.groupID }
}

@Observable
public final class AppGroupMainViewModel {

    public let timeOptions = [15, 20, 25, 30, 45, 60, 90, 120]
    var selectedMinutes: Int = 15
    var addGroupPresent: Bool = false
    var editAppGroup: AppGroup? = nil
    var appBrakeTimeSettingPresent: Bool = false
    var toastMessage: String? = nil
    var screenTimeAuthAlertPresent: Bool = false
    var brakeTimeSettingCompletePresent: Bool = false
    var screenTimeAuthErrorResult: ScreenTimeAuthorizationResult? = nil
    
    // 앱 정보 저장
    var selectedAppName: String = ""

    private var toastTask: Task<(), any Error>?

    private(set) var appGroups: [AppGroup] = []

    private let fetchAppGroupUseCase: FetchAppGroupUseCase
    private let requestScreenTimeAuthUseCase: RequestScreenTimeAuthUseCase
    private let createBreakTimeUseCase: CreateBreakTimeUseCaseProtocol
    private let fetchSelectedNotificationUseCase: FetchSelectedNotificationUseCaseProtocol
    private let fetchAppNameUseCase: FetchAppNameUseCaseProtocol

    public init(
        fetchAppGroupUseCase: FetchAppGroupUseCase,
        requestScreenTimeAuthUseCase: RequestScreenTimeAuthUseCase,
        createBreakTimeUseCase: CreateBreakTimeUseCaseProtocol,
        fetchSelectedNotificationUseCase: FetchSelectedNotificationUseCaseProtocol,
        fetchAppNameUseCase: FetchAppNameUseCaseProtocol
    ) {
        self.fetchAppGroupUseCase = fetchAppGroupUseCase
        self.requestScreenTimeAuthUseCase = requestScreenTimeAuthUseCase
        self.createBreakTimeUseCase = createBreakTimeUseCase
        self.fetchSelectedNotificationUseCase = fetchSelectedNotificationUseCase
        self.fetchAppNameUseCase = fetchAppNameUseCase
    }

    public func onAppear() {
        Task {
            await refreshAppGroups()
            loadAppBrakeTimeNotificationSetting()
            loadAppName()
        }
    }

    public func sceneActive() {
        Task {
            await screenTimeAuthRequest()
        }
    }

    public func reAuthButtonTapped() {
        Task {
            await screenTimeAuthRequest()
        }
    }

    public func addButtonTapped() {
        addGroupPresent.toggle()
    }

    public func editButtonTapped(appGroup: AppGroup) {
        self.editAppGroup = appGroup
    }

    private func loadAppBrakeTimeNotificationSetting() {
        Task {
            do {
                appBrakeTimeSettingPresent = try await fetchSelectedNotificationUseCase.execute()
            } catch {
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    self.toast(message: "알림 설정을 불러오는데 실패했습니다.")
                }
            }
        }
    }

    private func loadAppName() {
        Task {
            do {
                selectedAppName = try await fetchAppNameUseCase.execute() ?? ""
            } catch {
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    self.toast(message: "앱 이름을 불러오는데 실패했습니다.")
                }
            }
        }
    }

    public func brakeTimeSettingCompleteButtonTapped() {
        Task {
            do {
                try await createBreakTimeUseCase.execute(by: selectedMinutes)
                brakeTimeSettingCompletePresent.toggle()
            } catch {
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    self.toast(message: "휴게시간 설정에 실패했습니다.")
                }
            }
        }
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

    public func deleteCompleted(appGroup: AppGroup) {
        self.appGroups = []
        toast(message: "그룹이 삭제되었습니다.")
    }

    public func upsertCompleted(appGroup: AppGroup) {
        let message = appGroups.isEmpty ? "그룹이 추가되었습니다." : "그룹이 수정되었습니다."
        self.appGroups = [appGroup]
        toast(message: message)
    }
}

fileprivate extension AppGroupMainViewModel {
    func screenTimeAuthRequest() async {
        let result: ScreenTimeAuthorizationResult = await requestScreenTimeAuthUseCase.execute()
        await MainActor.run { [weak self] in
            guard let self else { return }
            self.screenTimeAuthErrorResult = result
            switch result {
            case .approved: screenTimeAuthAlertPresent = false
            default: screenTimeAuthAlertPresent = true
            }
        }
    }

    func toast(message: String) {
        self.toastTask?.cancel()
        self.toastMessage = nil
        self.toastTask = Task {
            await MainActor.run { [weak self] in
                guard let self else { return }
                toastMessage = message
            }
            try await Task.sleep(for: .seconds(1))
            await MainActor.run { [weak self] in
                guard let self else { return }
                toastMessage = nil
            }
        }
    }

    func refreshAppGroups() async {
        do {
            let appGroup = try await fetchAppGroupUseCase.execute()
            await MainActor.run { [weak self] in
                guard let self else { return }
                if let appGroup {
                    appGroups = [appGroup]
                } else {
                    appGroups = []
                }
            }
        } catch {
            await MainActor.run { [weak self] in
                guard let self else { return }
                self.toast(message: "그룹을 불러오는데 실패했습니다.")
            }
        }
    }
}
