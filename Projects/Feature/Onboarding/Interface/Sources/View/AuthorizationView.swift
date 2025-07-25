//
//  AuthorizationView.swift
//  FeatureOnboardingInterface
//
//  Created by Greem on 7/25/25.
//

import SwiftUI
import NotificationCenter
import FamilyControls
import UserNotifications



public struct AuthorizationView: View {
    
    @State private var isPresented: Bool = false
    
    @State private var screenTimeGrantPresented: Bool = false
    @State private var screenTimeAuthorizationResult: ScreenTimeAuthorizationResult?
    @State private var cancelScreenTimeGrantPresented: Bool = false
    @State private var notificationGrantPresented: Bool = false
    @State private var notificationAuthorizationResult: NotificationAuthorizationResult?
    
    let screenTimeTypes: [ScreenTimeAuthorizationResult] = [
        .denied,
        .unknownError,
        .authenticationMethodUnavailable ,
        .networkError,
        .restricted,
        .unavailableDevice
    ]
    public init() { }
    
    public var body: some View {
        ZStack {
            ScrollView {
                Rectangle().fill(.background).frame(height: 200)
                VStack(spacing: 40) {
                    VStack(spacing: 20) {
                        Button {
                            Task {
                                let center: AuthorizationCenter = AuthorizationCenter.shared
                                let status = center.authorizationStatus
                                switch status {
                                case .notDetermined:
                                    do {
                                        try await center.requestAuthorization(for: FamilyControlsMember.individual)
                                    } catch let error as FamilyControlsError {
                                        switch error {
                                        case .restricted, .invalidAccountType:
                                            self.screenTimeAuthorizationResult = .restricted
                                            self.screenTimeGrantPresented = true
                                        case .unavailable:
                                            self.screenTimeAuthorizationResult = .unavailableDevice
                                            self.screenTimeGrantPresented = true
                                        case .invalidArgument, .authorizationConflict:
                                            self.screenTimeAuthorizationResult = .unknownError
                                            self.screenTimeGrantPresented = true
                                        case .authorizationCanceled:
                                            self.cancelScreenTimeGrantPresented = true
                                        case .networkError:
                                            self.screenTimeAuthorizationResult = .networkError
                                            self.screenTimeGrantPresented = true
                                        case .authenticationMethodUnavailable:
                                            self.screenTimeAuthorizationResult = .authenticationMethodUnavailable
                                            self.screenTimeGrantPresented = true
                                        @unknown default:
                                            self.screenTimeAuthorizationResult = .unknownError
                                            self.screenTimeGrantPresented = true
                                        }
                                    } catch {
                                        self.screenTimeAuthorizationResult = .unknownError
                                        self.screenTimeGrantPresented = true
                                    }
                                case .denied:
                                    self.screenTimeAuthorizationResult = .denied
                                    self.screenTimeGrantPresented = true
                                case .approved: break
                                @unknown default:
                                    self.screenTimeAuthorizationResult = .unknownError
                                    self.screenTimeGrantPresented = true
                                }
                            }
                        } label: {
                            Text("스크린 타임 권한").font(.title)
                        }
                        
                        VStack(spacing: 8) {
                            
                            ForEach(screenTimeTypes.indices, id: \.self) { idx in
                                Button(screenTimeTypes[idx].alertTitle) {
                                    self.screenTimeAuthorizationResult = screenTimeTypes[idx]
                                    self.screenTimeGrantPresented = true
                                }
                            }
                            Button("authorizationCanceled") {
                                self.cancelScreenTimeGrantPresented = true
                            }
                        }
                    }
                    
                    
                    VStack(spacing: 20) {
                        Button {
                            Task {
                                let notificationSettings: UNNotificationSettings = await UNUserNotificationCenter.current().notificationSettings()
                                let status: UNAuthorizationStatus = notificationSettings.authorizationStatus
                                switch status {
                                case .notDetermined, .ephemeral, .provisional:
                                    let reqeustResult = try await UNUserNotificationCenter
                                        .current()
                                        .requestAuthorization(
                                            options: [ .alert, .badge, .sound ]
                                        )
                                    print("요청 결과: \(reqeustResult)")
                                    if reqeustResult { // 권한 요청 허용
                                        print("요청 허가에 따른 다른 처리하기")
                                    } else { // 권한 요청 거부
                                        notificationAuthorizationResult = .userRestricted
                                    }
                                case .denied:
                                    notificationAuthorizationResult = .denied
                                case .authorized: break
                                @unknown default:
                                    notificationAuthorizationResult = .unknownError
                                }
                            }
                        } label: {
                            Text("알림 노티피케이션 권한").font(.title)
                        }
                        
                        
                        VStack(spacing: 8) {
                            Button("userRestricted") {
                                self.notificationAuthorizationResult = .userRestricted
                                self.notificationGrantPresented = true
                            }
                            Button("Denied") {
                                self.notificationAuthorizationResult = .denied
                                self.notificationGrantPresented = true
                            }
                            Button("unknown error") {
                                self.notificationAuthorizationResult = .unknownError
                                self.notificationGrantPresented = true
                            }
                        }
                    }
                }
                .alert(
                    screenTimeAuthorizationResult?.alertTitle ?? "",
                    isPresented: $screenTimeGrantPresented,
                    presenting: screenTimeAuthorizationResult,
                    actions: { result in
                        switch result {
                        case .denied:
                            Button(role: .cancel) {
                                
                            } label: {
                                Text("취소")
                            }
                            
                        case .unknownError:
                            Button(role: .cancel) {
                                
                            } label: {
                                Text("확인")
                            }
                        case .unavailableDevice:
                            Button(role: .cancel) {
                                
                            } label: {
                                Text("확인")
                            }
                        case .networkError:
                            Button(role: .cancel) {
                                
                            } label: {
                                Text("확인")
                            }
                        case .restricted:
                            Button(role: .cancel) {
                                
                            } label: {
                                Text("확인")
                            }
                        case .authenticationMethodUnavailable:
                            Button(role: .cancel) {
                                
                            } label: {
                                Text("확인")
                            }
                        }
                    },
                    message: { result in
                        Text(result.alertDescription)
                    }
                )
                .alert(
                    notificationAuthorizationResult?.alertTitle ?? "",
                    isPresented: $notificationGrantPresented,
                    presenting: notificationAuthorizationResult,
                    actions: { result in
                        switch result {
                        case .denied:
                            Button {
                                if let url = URL(string: UIApplication.openSettingsURLString),
                                   UIApplication.shared.canOpenURL(url) {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }
                            } label: {
                                Text("설정으로 이동")
                            }
                            
                            Button(role: .cancel) {
                                
                            } label: {
                                Text("취소")
                            }
                        case .unknownError:
                            Button(role: .cancel) {
                                
                            } label: {
                                Text("확인")
                            }
                            
                        case .userRestricted:
                            Button(role: .cancel) {
                                
                            } label: {
                                Text("확인")
                            }
                        }
                    },
                    message: { result in
                        switch result {
                        case .denied: Text("설정에서 권한을 허용해주세요")
                        case .userRestricted: Text("설정에서 권한을 허용해주세요")
                        case .unknownError: Text("나중에 다시 시도 해주세요")
                        }
                    }
                )
                
            }
            if cancelScreenTimeGrantPresented {
                Rectangle().fill(.background).overlay {
                    VStack {
                        Text("요청이 취소되었습니다. 권한을 허가해야 넘어갈 수 있어욤")
                        Button {
                            cancelScreenTimeGrantPresented = false
                        } label: {
                            Text("확인")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    AuthorizationView()
}
