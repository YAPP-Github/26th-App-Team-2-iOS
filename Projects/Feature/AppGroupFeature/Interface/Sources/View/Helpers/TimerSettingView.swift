//
//  TimerSettingView.swift
//  FeatureAppGroupFeatureInterface
//
//  Created by Greem on 8/1/25.
//

import SwiftUI
import SharedDesignSystem

public struct TimerSettingView: View {
    @Environment(\.dismiss) var dismiss
    
    // 10분부터 60분까지 5분 단위로 배열 생성
    @State private var selectedMinutes: Int = 30
    private let timeOptions = Array(stride(from: 15, through: 60, by: 5))
    
    // 값을 넘길 콜백
    private let onSelect: (Int) -> Void
    
    public init(onSelect: @escaping (Int) -> Void) {
        self.onSelect = onSelect
    }
    
    public var body: some View {
        ZStack {
            Color.grey900.ignoresSafeArea()
            VStack(spacing: 0) {
                BrakeNavigationView(title: EmptyView(), trailing: {
                    BrakeNavigationButton(type: .cancel) {
                        dismiss()
                    }
                })
                
                VStack(spacing: 16) {
                    Text("타이머 설정")
                        .font(.pretendard(size: 24, type: .semiBold))
                    Text("사용 시간을 선택해주세요")
                        .font(.pretendard(size: 16, type: .medium))
                        .foregroundColor(.secondary)
                }.padding(.top, 16)
                Spacer()
            }
            VStack(spacing: 20) {
                // 선택된 시간 표시
                VStack(spacing: 8) {
                    Text("\(selectedMinutes)분")
                        .font(.pretendard(size: 55, type: .semiBold))
                        .foregroundStyle(Color.grey00)
                    
                    Text("선택된 시간")
                        .font(.pretendard(size: 16, type: .regular))
                        .foregroundStyle(Color.grey300)
                }
                .padding(.vertical, 20)
                
                // 시간 선택 Picker
                Picker("시간 선택", selection: $selectedMinutes) {
                    ForEach(timeOptions, id: \.self) { minutes in
                        Text("\(minutes)분")
                            .tag(minutes)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(height: 150)
            }
            .padding(.horizontal, 16)
            VStack {
                Spacer()
                LargeButtonView(buttonType: .confirm, title: "확인", isActive: true) {
                    onSelect(selectedMinutes)
                }
                .padding(.bottom, 16)
            }.padding(.horizontal, 16)
        }
        
    }
}
