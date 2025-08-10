//
//  AccountSectionView.swift
//  FeatureMyInfo
//
//  Created by Derrick kim on 8/2/25.
//

import SwiftUI
import Combine

public struct AccountSectionView: View {
    private let accountSubject: PassthroughSubject<SettingAction, Never>

    public init(
        accountSubject: PassthroughSubject<SettingAction, Never>
    ) {
        self.accountSubject = accountSubject
    }

    public var body: some View {
        VStack(spacing: 2) {
            MyInfoMainSettingCell(title: AccountSection.logout.title, showChevron: true) {
                accountSubject.send(.logout)
            }
            
            MyInfoMainSettingCell(title: AccountSection.withdraw.title, showChevron: true) {
                accountSubject.send(.withdraw)
            }
        }
        .cornerRadius(16)
    }
    
    private func menuItem(title: String, showChevron: Bool, action: @escaping () -> Void) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.grey300)
                .font(.pretendard(size: 16, type: .medium))

            Spacer()
            
            if showChevron {
                Image.iconTinyArrow
                    .foregroundColor(.grey600)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .contentShape(Rectangle())
        .onTapGesture {
            action()
        }
    }
} 
