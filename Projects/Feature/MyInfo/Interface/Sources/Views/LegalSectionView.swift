//
//  LegalSectionView.swift
//  FeatureMyInfo
//
//  Created by Derrick kim on 8/2/25.
//

import SwiftUI
import Combine

public struct LegalSectionView: View {
    private let appVersion: String
    private let legalSubject: PassthroughSubject<SettingAction, Never>

    public init(
        appVersion: String,
        legalSubject: PassthroughSubject<SettingAction, Never>
    ) {
        self.appVersion = appVersion
        self.legalSubject = legalSubject
    }

    public var body: some View {
        VStack(spacing: 0) {
            menuItem(title: LegalSection.privacyPolicy.title, showChevron: true) {
                legalSubject.send(.privacyPolicy)
            }
            
            Divider()
                .frame(height: 2)
                .background(Color.grey800)
            
            menuItem(title: LegalSection.termsOfService.title, showChevron: true) {
                legalSubject.send(.termsOfService)
            }
            
            Divider()
                .frame(height: 2)
                .background(Color.grey800)
            
            menuItem(title: LegalSection.appVersion.title, showChevron: false, subtitle: appVersion) {
                // 액션 없음
            }
        }
        .background(Color.grey850)
        .cornerRadius(16)
    }
    
    private func menuItem(title: String, showChevron: Bool, subtitle: String? = nil, action: @escaping () -> Void) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.grey300)
                .font(.pretendard(size: 16, type: .medium))

            Spacer()
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .foregroundColor(.grey600)
                    .font(.pretendard(size: 14, type: .regular))
            }
            
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
