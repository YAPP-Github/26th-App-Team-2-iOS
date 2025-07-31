//
//  AppGroupMainEmptyAppGroupView.swift
//  FeatureAppGroupFeatureInterface
//
//  Created by Greem on 7/29/25.
//

import SwiftUI
import SharedDesignSystem

extension AppGroupMainView {
    struct AppGroupMainEmptyAppGroupView: View {
        let addButtonTapped: () -> Void
        var body: some View {
            ZStack {
                GeometryReader { geometry in
                    VStack {
                        // 위 절반 영역
                        VStack {
                            Image.appGroup.mainEmpty
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        .frame(height: geometry.size.height / 2) // 화면 높이 절반
                        .overlay(alignment: .bottom) {
                            let halfHeight = geometry.size.height / 4
                            VStack(spacing: 0) {
                                LinearGradient(
                                    stops: [
                                        .init(color: Color.grey900.opacity(1), location: 0),
                                        .init(color: Color.grey900.opacity(0.7), location: 0.27),
                                        .init(color: .clear, location: 1)
                                    ],
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                                .frame(height: halfHeight * 0.5)
                                Color.grey900.frame(height: halfHeight * 0.5)
                            }
                        }
                        Spacer() // 아래 절반은 비워둠
                    }.padding(.horizontal, 42)
                    
                }
                VStack(spacing: 24) {
                    VStack(spacing: 10) {
                        Text("스크린타임, 이제 줄여볼까요?")
                            .font(.pretendard(size: 22, type: .semiBold))
                            .foregroundStyle(Color.grey00)
                        Text("사용을 자제할 앱을 추가해주세요.")
                            .font(.pretendard(size: 16, type: .medium))
                            .foregroundStyle(Color.grey200)
                    }
                    Button {
                        addButtonTapped()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "plus")
                            Text("추가")
                        }
                        .tint(.grey800)
                        .font(.pretendard(size: 16, type: .bold))
                        .padding(.horizontal, 18.5)
                        .padding(.vertical, 10.5)
                        .background(Color.brakeYellow)
                        .cornerRadius(16)
                    }
                }
            }
        }
    }
}

