//
//  BrakeToastView.swift
//  SharedDesignSystem
//
//  Created by Derrick kim on 7/27/25.
//

import SwiftUI

public struct BrakeToastView: View {
    
    private let message: String
    private let backgroundColor: Color
    private let textColor: Color
    
    public init(
        message: String,
        backgroundColor: Color = .grey850,
        textColor: Color = Color.white
    ) {
        self.message = message
        self.backgroundColor = backgroundColor
        self.textColor = textColor
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            // 아이콘
            Image.iconCheckInsightBlue
                .frame(width: 24, height: 24)
                .clipShape(Circle())
            
            // 메시지
            Text(message)
                .font(.pretendard(size: 14, type: .medium))
                .foregroundStyle(textColor)
                .lineLimit(2)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .frame(height: 60)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

public extension View {
    func toast(
        message: String?,
        bottomPadding: CGFloat = 56
    ) -> some View {
        self.modifier(
            ToastMessageModifier(
                message: message,
                bottomPadding: bottomPadding
            )
        )
    }
    
    func toast(show: Bool) -> some View{
        self.modifier(ToastViewModifier(show: show))
    }
}

struct ToastMessageModifier: ViewModifier {
    public let message: String?
    public let bottomPadding: CGFloat
    @State private var showMessage: String = ""
    @State private var isPresented: Bool = false
    @State private var showing: Bool = false

    func body(content: Content) -> some View {
        content.overlay {
            VStack {
                Spacer()
                if isPresented {
                    BrakeToastView(message: showMessage)
                        .opacity(showing ? 1 : 0)
                        .offset(y: showing ? 0 : 10)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 40)
                        .transition(.move(edge: .bottom))
                }
            }
            .padding(.bottom, bottomPadding)
            .onChange(of: message) { oldValue, newValue in
                guard let newValue else { return }
                self.showMessage = newValue
                isPresented = true
                showing = false
                Task { @MainActor in
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showing = true
                    }
                    try? await Task.sleep(for: .seconds(1.0)) // 보여지는 시간
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showing = false
                    }
                    try await Task.sleep(for: .seconds(0.3))
                    isPresented = false
                    showMessage = ""
                }
            }
        }
    }
}

struct ToastViewModifier: ViewModifier {
    public let show: Bool
    
    @State private var isPresented: Bool = false
    @State private var showing: Bool = false
    func body(content: Content) -> some View {
        content.overlay {
            VStack {
                Spacer()
                if isPresented {
                    BrakeToastView(message: "완료되었습니다!")
                        .padding(.horizontal, 16)
                        .padding(.bottom, 40)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.easeOut(duration: 0.3), value: showing)
                }
            }
            .task {
                try? await Task.sleep(for: .seconds(0.05))
                withAnimation(.easeInOut(duration: 0.3)) {
                    self.showing = true
                }

                try? await Task.sleep(for: .seconds(0.3))
                showing = true
            }
            .onChange(of: show) { oldValue, newValue in
                if newValue {
                    isPresented = true
                    
                } else {
                    withAnimation(.easeInOut(duration: 0.3), completionCriteria: .removed) {
                        showing = false
                    } completion: {
                        self.isPresented = false
                    }
                }
            }
        }
    }
}
