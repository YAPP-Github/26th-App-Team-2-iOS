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

public extension Color {
    public init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit), like "F0A"
            (a, r, g, b) = (255,
                            (int >> 8) * 17,
                            (int >> 4 & 0xF) * 17,
                            (int & 0xF) * 17)
        case 6: // RRGGBB (24-bit), like "FF00AA"
            (a, r, g, b) = (255,
                            int >> 16,
                            int >> 8 & 0xFF,
                            int & 0xFF)
        case 8: // AARRGGBB (32-bit), like "CCFF00AA"
            (a, r, g, b) = (int >> 24,
                            int >> 16 & 0xFF,
                            int >> 8 & 0xFF,
                            int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0) // 잘못된 값일 때 검은색
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
