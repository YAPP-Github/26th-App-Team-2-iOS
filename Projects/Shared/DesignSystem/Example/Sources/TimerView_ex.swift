//
//  TimerView_ex.swift
//  SharedDesignSystemExample
//
//  Created by Greem on 7/31/25.
//

import SwiftUI
import SharedDesignSystem
extension Image: @retroactive AppGroupImagesProtocol { }
struct TimerView_ex: View {
    @State private var progress: CGFloat = 0
    @State private var coolDownProgress: CGFloat = 0
    var body: some View {
        ScrollView {
            VStack {
                BrakeTimerView(
                    lineWidth: 7,
                    progress: progress,
                    startColor: Color(hex: "#B6C1E0"),
                    endColor: Color.brakeYellow
                ) {
                    VStack(alignment: .center, spacing: 0) {
                        Text("남은 사용 시간")
                            .foregroundStyle(Color.grey400)
                            .font(.pretendard(size: 14, type: .medium))
                            .multilineTextAlignment(.center)
                            .frame(height: 21)
                        BrakeTimerTextView(minutes: 12, seconds: 07)
                        .frame(height: 54)
                    }
                }
                .padding()
                .frame(width: 275, height: 275)
                .onAppear() {
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                        progress = 0
                        withAnimation {
                            progress = 1
                        }
                    }
                }
                
                BrakeTimerView(
                    lineWidth: 7,
                    progress: coolDownProgress,
                    startColor: Color(hex: "#F0F4FF"),
                    endColor: Color(hex: "#8E97B0")
                ) {
                    VStack(spacing: 12) {
                        Image.appGroup.lockTimer
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 110)
                        HStack(spacing: 4) {
                            ( Text(String(format: "%02d", 54))
                                .foregroundStyle(Color.grey00)
                              +
                              Text("분").foregroundStyle(Color.grey500)
                            )
                            ( Text(String(format: "%02d", 54)).foregroundStyle(Color.grey00)
                              +
                              Text("초").foregroundStyle(Color.grey500)
                            )
                        }.font(.pretendard(size: 14, type: .bold))
                    }
                    
                }
                .padding(32)
                .onAppear() {
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                        self.coolDownProgress = 0
                        withAnimation {
                            self.coolDownProgress = 1
                        }
                    }
                }
            }
        }
        
    }
    
}

fileprivate struct BrakeTimerTextView: View {
    let minutes: Int
    let seconds: Int
    var body: some View {
        HStack(spacing: 3.5) {
            if minutes > 0 {
                HStack(alignment: .lastTextBaseline, spacing: 5) {
                    Text(String(format: "%02d", minutes))
                        .foregroundStyle(Color.grey00)
                        .font(.pretendard(size: 45, type: .medium))
                    Text("분").foregroundStyle(Color.grey300)
                        .font(.pretendard(size: 14, type: .medium))
                }
            }
            HStack(alignment: .lastTextBaseline, spacing: 5) {
                Text(String(format: "%02d", seconds))
                    .foregroundStyle(Color.grey00)
                    .font(.pretendard(size: 45, type: .medium))
                Text("초").foregroundStyle(Color.grey300)
                    .font(.pretendard(size: 14, type: .medium))
            }
        }.frame(height: 54)
    }
}
