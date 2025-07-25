//
//  ScreenTimeAuthView.swift
//  FeatureOnboardingInterface
//
//  Created by Greem on 7/25/25.
//

import SwiftUI

public struct ScreenTimeAuthView: View {
    @Environment(ScreenTimeAuthViewModel.self) var screenTimeAuthViewModel
    @State private var sheet: Bool = false
    public init() { }
    
    public var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Button {
                    self.screenTimeAuthViewModel.authorizationButtonTapped()
                } label: {
                    Text("스크린 타임 권한").font(.title)
                }
                
                Button {
                    self.screenTimeAuthViewModel.cancelScreenTimeGrantPresented = true
                } label: {
                    Text("Cancel 결과 테스트").font(.title)
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
            screenTimeAuthViewModel.screenTimeAuthorizationResult?.alertTitle ?? "",
            isPresented: .init(get: {
                screenTimeAuthViewModel.screenTimeGrantPresented
            }, set: {
                screenTimeAuthViewModel.screenTimeGrantPresented = $0
            }),
            presenting: screenTimeAuthViewModel.screenTimeAuthorizationResult,
            actions: { result in
                Button("확인", role: .cancel, action: {})
            },
            message: { result in
                Text(result.alertDescription)
            }
        )
    }
}
