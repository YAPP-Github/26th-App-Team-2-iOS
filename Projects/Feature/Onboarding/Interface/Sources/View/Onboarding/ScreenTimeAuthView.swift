//
//  ScreenTimeAuthView.swift
//  FeatureOnboardingInterface
//
//  Created by Greem on 7/25/25.
//

import SwiftUI
import Domain
import SharedDesignSystem

public struct ScreenTimeAuthView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(StartUpViewModel.self) private var startUpViewModel
    @Environment(ScreenTimeAuthViewModel.self) private var screenTimeAuthViewModel
    
    
    public init() { }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            Color.grey900.ignoresSafeArea()
            VStack(spacing: 0) {
                BrakeNavigationView(title: EmptyView(), leading: {
                    BrakeNavigationButton(type: .back) {
                        dismiss()
                    }
                })
                VStack(alignment: .center, spacing: 16) {
                    VStack(alignment: .center, spacing: 0) {
                        Text("스크린 타임 권한을").frame(height: 33)
                        Text("허용해주세요.").frame(height: 33)
                    }
                    .foregroundStyle(.white)
                    .font(.pretendard(size: 22, type: .semiBold))
                    Text("앱 사용량을 모니터링해요.")
                        .foregroundStyle(Color.grey200)
                        .font(.pretendard(size: 16, type: .medium))
                }
                .padding(.top, 47)
                Spacer()
            }
            
            
            
            GeometryReader { proxy in
                ZStack {
                    Color.clear
                    Image.onboarding.screentime
                        .resizable()
                        .frame(width: proxy.size.width * 0.688)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            LargeButtonView(
                buttonType: .confirm,
                title: "허용하기",
                isActive: true
            ) {
                screenTimeAuthViewModel.authorizationButtonTapped()
            }
            .padding(.bottom, 16)
        }
        .toolbar(.hidden, for: .navigationBar)
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
