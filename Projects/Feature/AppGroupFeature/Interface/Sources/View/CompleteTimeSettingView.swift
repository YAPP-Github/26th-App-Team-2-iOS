//
//  CompleteTimeSettingView.swift
//  FeatureAppGroupFeatureInterface
//
//  Created by Derrick kim on 8/3/25.
//

import SwiftUI
import SharedDesignSystem

public struct CompleteTimeSettingView: View {
    @Environment(\.dismiss) private var dismiss
    private let selectedMinutes: Int
    private let endTime: String
    public init(
        selectedMinutes: Int,
        endTime: String
    ) {
        self.selectedMinutes = selectedMinutes
        self.endTime = endTime
    }

    public var body: some View {
        ZStack {
            Color.grey900.ignoresSafeArea()
            VStack {
                // 상단 알림 박스 - 최상단 왼쪽에서 16만큼 이동, 상단에서 9만큼 내려온 위치
                VStack(alignment: .leading, spacing: 8) {
                    Text("설정 완료")
                        .font(.pretendard(size: 14, type: .semiBold))
                        .foregroundColor(.brakeWhite)

                    HStack(spacing: 4) {
                        Image.iconPolygon
                            .frame(width: 12, height: 12)
                            .foregroundColor(.brakeWhite)

                        Text("버튼을 눌러 사용할 앱으로 돌아가세요")
                            .font(.pretendard(size: 14, type: .medium))
                            .foregroundColor(.brakeWhite)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.grey850)
                )
                .padding(.leading, 16)
                .padding(.top, 9)
                .frame(maxWidth: .infinity, alignment: .leading)
                .onTapGesture {
                    dismiss()
                }

                Spacer()
            }

            // 중앙 콘텐츠
            VStack(spacing: 12) {
                Spacer()

                // 중앙 스톱워치 아이콘
                Image.illustBlock
                    .frame(width: 136, height: 136)

                // 시간 표시
                VStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Text("\(selectedMinutes)")
                            .font(.pretendard(size: 48, type: .bold))
                            .foregroundColor(.brakeWhite)

                        Text("분")
                            .font(.pretendard(size: 24, type: .medium))
                            .foregroundColor(.brakeWhite)
                            .offset(y: 8)
                    }

                    Text(endTime)
                        .font(.pretendard(size: 16, type: .medium))
                        .foregroundColor(.grey300)
                }

                Spacer()
                Spacer()
            }
            .padding(.horizontal, 16)
        }
    }
}
