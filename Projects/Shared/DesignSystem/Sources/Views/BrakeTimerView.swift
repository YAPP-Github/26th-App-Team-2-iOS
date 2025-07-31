//
//  BrakeTimerView.swift
//  SharedDesignSystemExample
//
//  Created by Greem on 7/31/25.
//

import SwiftUI


public struct BrakeTimerView<ContentView: View>: View {
    
    private let lineWidth: CGFloat
    private let progress: Double
    private let startColor: Color
    private let endColor: Color
    private let content: ContentView
    public init(
        lineWidth: CGFloat,
        progress: Double,
        startColor: Color,
        endColor: Color,
        content: @escaping () -> ContentView
    ) {
        self.content = content()
        self.startColor = startColor
        self.endColor = endColor
        self.lineWidth = lineWidth
        self.progress = progress
    }
    public init(
        lineWidth: CGFloat,
        progress: Double,
        startColor: Color,
        endColor: Color
    ) where ContentView == EmptyView {
        self.lineWidth = lineWidth
        self.progress = progress
        self.startColor = startColor
        self.endColor = endColor
        self.content = EmptyView()
    }
    
    
    public var body: some View {
        ZStack(alignment: .center) {
            GeometryReader { proxy in
                let r = proxy.size.width * 0.5
                let lineWidth: CGFloat = 7
                let lineCapDegrees = ceil(lineWidth * 500 / r) / 1000
                let duration = ceil((lineWidth * 0.5) * 1000 / proxy.size.width) / 1000
                ZStack(alignment: .center) {
                    Circle()
                        .stroke(
                            Color.grey600,
                            lineWidth: 7
                        )
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            AngularGradient(stops: [
                                .init(color: startColor, location: 0),
                                .init(color: endColor, location: 1 - duration),
                                .init(color: startColor, location: 1)
                            ], center: .center),
                            style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                        )
                        .blur(radius: 20)
                        .rotationEffect(.degrees(-90 + lineCapDegrees))
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            AngularGradient(stops: [
                                .init(color: startColor, location: 0),
                                .init(color: endColor, location: 1 - duration),
                                .init(color: startColor, location: 1)
                            ], center: .center),
                            style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90 + lineCapDegrees))
                }
                .overlay {
                    content
                }
            }
            .aspectRatio(1, contentMode: .fit)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
