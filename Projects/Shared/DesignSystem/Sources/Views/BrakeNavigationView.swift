//
//  BrakeNavigationView.swift
//  SharedDesignSystem
//
//  Created by Derrick kim on 7/27/25.
//

import SwiftUI

public struct BrakeNavigationView<TitleView: View, LeadingView: View, TrailingView: View>: View {
    
    private let title: TitleView
    private let leadingView: LeadingView
    private let trailingView: TrailingView
    
    public init(
        title: String,
        onBackButtonTapped: @escaping () -> Void,
        onCloseButtonTapped: @escaping () -> Void
    ) where TitleView == AnyView, LeadingView == AnyView, TrailingView == AnyView {
        self.title = AnyView(
            Text(title)
                .font(.pretendard(size: 18, type: .semiBold))
                .foregroundStyle(Color.brakeWhite)
        )
        self.leadingView =
        AnyView(
            Button {
                onBackButtonTapped()
            } label: {
                Image.iconBack
                    .foregroundStyle(Color.grey300)
                    .frame(width: 32, height: 32)
                    .background(Color.grey800)
                    .clipShape(Circle())
            }
                .buttonStyle(.plain)
        )
        self.trailingView = AnyView(
            Button {
                onCloseButtonTapped()
            } label: {
                Image.iconCancel
                    .foregroundStyle(Color.grey300)
                    .frame(width: 32, height: 32)
                    .background(Color.grey800)
                    .clipShape(Circle())
            }
                .buttonStyle(.plain)
        )
    }
    
    public init(
         title: @autoclosure () -> TitleView,
        @ViewBuilder leading: () -> LeadingView,
        @ViewBuilder trailing: () -> TrailingView
    ) {
        self.title = title()
        self.leadingView = leading()
        self.trailingView = trailing()
    }
    
    public init(
        title: @autoclosure () -> TitleView,
        @ViewBuilder trailing: () -> TrailingView
    ) where LeadingView == EmptyView {
        self.title = title()
        self.leadingView = EmptyView()
        self.trailingView = trailing()
    }
    
    public init(
        title: @autoclosure () -> TitleView,
        @ViewBuilder leading: () -> LeadingView
    ) where TrailingView == EmptyView {
        self.title = title()
        self.leadingView = leading()
        self.trailingView = EmptyView()
    }
    
    public init(
        title: @autoclosure () -> TitleView
    ) where LeadingView == EmptyView, TrailingView == EmptyView {
        self.title = title()
        self.leadingView = EmptyView()
        self.trailingView = EmptyView()
    }
    
    public var body: some View {
        HStack {
            leadingView
            Spacer()
            trailingView
        }
        .overlay(content: {
            title
        })
        .padding(.horizontal, 20)
        .frame(height: 56)
        .background(Color.grey900)
    }
}

public struct BrakeNavigationButton: View {
    public enum NaviBtnType {
        case edit
        case back
        case cancel
    }
    let type: NaviBtnType
    let action: () -> ()
    
    public init(type: NaviBtnType, action: @escaping () -> Void) {
        self.type = type
        self.action = action
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            Group {
                switch type {
                case .back:
                    Image.iconBack
                case .cancel:
                    Image.iconCancel
                case .edit:
                    Image.iconEdit
                }
            }
            .foregroundStyle(Color.grey300)
            .frame(width: 32, height: 32)
            .background(Color.grey800)
            .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}
