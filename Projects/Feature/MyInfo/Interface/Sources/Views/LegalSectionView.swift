//
//  LegalSectionView.swift
//  FeatureMyInfo
//
//  Created by Derrick kim on 8/2/25.
//

import SwiftUI
import Combine
import SharedUtil

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
        VStack(spacing: 2) {
            
            MyInfoMainSettingCell(title: ExternalLink.privacyPolicy.title, showChevron: true) {
                legalSubject.send(.privacyPolicy)
            }
            
            
            MyInfoMainSettingCell(title: ExternalLink.termsOfService.title, showChevron: true) {
                legalSubject.send(.termsOfService)
            }
            
            
            MyInfoMainSettingCell(title: ExternalLink.appVersion.title, subtitle: appVersion)
        }
        .cornerRadius(16)
    }
    
} 
