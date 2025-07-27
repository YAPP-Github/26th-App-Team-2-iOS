//
//  ScreenTimeAuthView.swift
//  FeatureOnboardingInterface
//
//  Created by Greem on 7/25/25.
//

import SwiftUI

public struct ScreenTimeAuthView: View {
    @Environment(StartUpViewModel.self) var startUpViewModel
    @Environment(ScreenTimeAuthViewModel.self) var screenTimeAuthViewModel
    
    private let screenTimeTypes: [ScreenTimeAuthorizationResult] = [
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
            VStack(spacing: 20) {
                Button {
                    self.screenTimeAuthViewModel.authorizationButtonTapped()
                } label: {
                    Text("스크린 타임 권한").font(.title)
                }
                VStack(spacing: 8) {
                    Text("임시 확인차 생성 뷰")
                    ForEach(screenTimeTypes.indices, id: \.self) { idx in
                        Button(screenTimeTypes[idx].alertTitle) {
                            self.screenTimeAuthViewModel.screenTimeAuthFailedResult = screenTimeTypes[idx]
                            self.screenTimeAuthViewModel.screenTimeAuthFailedPresent = true
                        }
                    }
                    
                    Button("authorizationCanceled") {
                        self.screenTimeAuthViewModel.cancelScreenTimeGrantPresented = true
                    }
                }
            }
        }
        .alert(isPresented: .init(get: {
            screenTimeAuthViewModel.cancelScreenTimeGrantPresented
        }, set: { 
            screenTimeAuthViewModel.cancelScreenTimeGrantPresented = $0
        }), content: {
            VStack(spacing: 20) {
                Text("Brake Alert").font(.title)
                VStack {
                    Text("여기에 추가적인 콘텐츠를 넣으세요")
                    Button {
                        self.screenTimeAuthViewModel.cancelScreenTimeGrantPresented = false
                    } label: {
                        Text("Dismiss")
                    }
                }
            }
            .padding(15)
            .background(.background, in: .rect(cornerRadius: 10))
            .transition(.blurReplace)
        }, background: {
            Rectangle().fill(.primary.opacity(0.35))
        })
        .alert(
            screenTimeAuthViewModel.screenTimeAuthFailedResult?.alertTitle ?? "",
            isPresented: .init(get: {
                screenTimeAuthViewModel.screenTimeAuthFailedPresent
            }, set: {
                screenTimeAuthViewModel.screenTimeAuthFailedPresent = $0
            }),
            presenting: screenTimeAuthViewModel.screenTimeAuthFailedResult,
            actions: { result in
                Button("확인", role: .cancel, action: {})
            },
            message: { result in
                Text(result.alertDescription)
            }
        )
    }
}
