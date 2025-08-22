//
//  BrakeTimeWheelPickerView.swift
//  FeatureAppGroupFeatureInterface
//
//  Created by Greem on 8/22/25.
//

import SwiftUI
import SharedDesignSystem

public struct BrakeTimeWheelPickerView: View {
    @Environment(AppBrakeTimeSettingViewModel.self) var viewModel
    @State private var count: Int = 0
    
    // Кange of values to be used.
    var values: ClosedRange<Int> = 1...10
    
    // Horizontal spacing between segments.
    private let spacing: Double = 90
    
    
    public init() { }
    
    private let holeCenterOffset: CGFloat = 17
    public let pickerHeight: CGFloat = 300
    private let scrollViewProxyID: String = "scroll"
    
    public var body: some View {
        ZStack {
            GeometryReader { proxy in
                ScrollView(.vertical) {
                    VStack(spacing: spacing) {
                        ForEach(viewModel.timeOptions.indices, id: \.self) { idx in
                            GeometryReader { innerProxy in
                                let y = innerProxy.frame(in: .named(scrollViewProxyID)).midY
                                let midY = proxy.frame(in: .named(scrollViewProxyID)).midY - holeCenterOffset
                                let distance = midY - y;
                                let normalizedDistance = abs(y + 12 - pickerHeight * 0.5) / (pickerHeight * 0.5)
                                let scaleFactor = 1.0 - pow(normalizedDistance, 2.0)
                                let angle = Angle(degrees: Double((distance - pickerHeight)) / 250)
                                let dis = max(0.6, scaleFactor)
                                let opacity = max(0.4, scaleFactor)
                        
                                HStack {
                                    Spacer()
                                    Text("\(viewModel.timeOptions[idx])")
                                        .font(.pretendard(size: 55 * dis, type: .semiBold))
                                        .foregroundStyle(Color.grey00)
                                        .opacity(opacity)
                                        .fixedSize()
                                    Spacer()
                                }.id(idx)
                                .rotation3DEffect(angle, axis: (x: 1, y: 0, z: 0), perspective: 0.5)
                                .frame(height: innerProxy.size.height)
                            }
                        }
                    }
                    .scrollTargetLayout()
                    .padding(.horizontal, 16)
                    .offset(y: -holeCenterOffset)
                }
                .maskOverLay(endTime: viewModel.endTime)
                .scrollIndicators(.hidden)
                .safeAreaPadding(.vertical, proxy.size.height / 2.0)
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: .init(
                    get: { count },
                    set: { value in
                        if let value { count = value }
                    }
                ))
                .coordinateSpace(name: scrollViewProxyID)
            }
        }
        .frame(height: pickerHeight)
        .sensoryFeedback(.selection, trigger: count)
        .onChange(of: count) { prev, next in
            viewModel.updateSelectedTime(to: next);
        }
    }
    
}

fileprivate extension View {
    @ViewBuilder
    func maskOverLay(endTime: String) -> some View {
        self.overlay {
            ZStack(alignment: .center){
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.grey850)
                    .frame(height: 133)
                VStack(spacing: 14) {
                    RoundedRectangle(cornerRadius: 16).frame(width: 98, height: 70)
                        .blendMode(.destinationOut)
                        .overlay(alignment: .bottomTrailing) {
                            Text("분")
                                .font(.pretendard(size: 16, type: .regular))
                                .offset(x: 18, y: -9)
                                .foregroundStyle(Color.grey50)
                        }
                    
                    Text("\(endTime)까지")
                        .font(.pretendard(size: 16, type: .regular))
                        .foregroundStyle(Color.grey300)
                        .frame(height: 20)
                }
            }
            .compositingGroup()
            .allowsHitTesting(false)
        }
    }
}
