//
//  MainAppViewModel.swift
//  Brake
//
//  Created by Greem on 8/12/25.
//

import Foundation
import Domain

@Observable
final class MainAppViewModel {
    var authFailedPresented: AuthFailed? = nil
    
    private let fetchScreenTimeAuthUseCase: FetchScreenTimeAuthUseCase
    private let fetchNotificationAuthUseCase: FetchUserNotificationAuthUseCase
    
    init(
        fetchScreenTimeAuthUseCase: FetchScreenTimeAuthUseCase,
        fetchNotificationAuthUseCase: FetchUserNotificationAuthUseCase
    ) {
        self.fetchScreenTimeAuthUseCase = fetchScreenTimeAuthUseCase
        self.fetchNotificationAuthUseCase = fetchNotificationAuthUseCase
    }
    
    func onAppear() {
        Task {
            await setAuthorizationStatus()
        }
    }
    
    func sceneActive() {
        Task {
            await setAuthorizationStatus()
        }
    }
    
    private func setAuthorizationStatus() async {
        let screenTimeAuthorizationResult = fetchScreenTimeAuthUseCase.execute()
        let notificationAuthorizationResult = await fetchNotificationAuthUseCase.execute()
        let isApprovedScreenTime =  switch screenTimeAuthorizationResult {
            case .approved: true
            default: false
        }
        let isApprovedNotification = switch notificationAuthorizationResult {
            case .approved: true
            default: false
        }
        
        await MainActor.run { [weak self] in
            guard let self else { return }
            if !isApprovedNotification && !isApprovedScreenTime {
                self.authFailedPresented = .both
            } else if !isApprovedNotification {
                self.authFailedPresented = .notification
            } else if !isApprovedScreenTime {
                self.authFailedPresented = .screenTime
            } else {
                self.authFailedPresented = nil
            }
        }
    }
}
