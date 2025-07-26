//
//  TimerSettingView.swift
//  CoreAppScreenTimeExample
//
//  Created by Derrick kim on 7/26/25.
//

import SwiftUI

struct TimerSettingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedMinutes: Int = 30
    
    // 10분부터 60분까지 5분 단위로 배열 생성
    private let timeOptions = Array(stride(from: 10, through: 60, by: 5))
    
    // 값을 넘길 콜백
    var onSelect: (Int) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("타이머 설정")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)
            
            Text("사용 시간을 선택해주세요")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // 선택된 시간 표시
            VStack(spacing: 8) {
                Text("\(selectedMinutes)분")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("선택된 시간")
                    .font(.caption)
                    .foregroundColor(.secondary)
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
            
            // 확인 버튼
            Button(action: {
                onSelect(selectedMinutes)
                dismiss()
            }) {
                Text("확인")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    TimerSettingView(onSelect: { minutes in
        
    })
}
