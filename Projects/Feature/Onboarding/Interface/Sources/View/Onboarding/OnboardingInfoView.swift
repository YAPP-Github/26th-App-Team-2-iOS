//
//  OnboardingInfoView.swift
//  FeatureOnboardingInterface
//
//  Created by Greem on 7/26/25.
//

import SwiftUI






public struct OnboardingInfoView: View {
    @Environment(StartUpViewModel.self) var startUpViewModel
    @Environment(OnboardingManager.self) var onboardingManager
    
    private let onboardinInfoTypes: [OnboardingInfoType] = OnboardingInfoType.allCases
    
    @State private var selectedInfoType: OnboardingInfoType = .intro
    private let infoCompleted: ()->()
    
    public init(
        infoCompleted: @escaping () -> ()
    ) {
        self.infoCompleted = infoCompleted
    }
    
    public var body: some View {
        VStack {
            TabView(selection: $selectedInfoType) {
                ForEach(onboardinInfoTypes) { infoType in
                    VStack {
                        Text(infoType.desc)
                    }
                    .tag(infoType)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            
            Button {
                withAnimation {
                    switch selectedInfoType {
                    case .intro: self.selectedInfoType = .extensionInfo
                    case .extensionInfo: self.selectedInfoType = .restrictionInfo
                    case .restrictionInfo: infoCompleted()
                    }
                }
            } label: {
                Text("확인")
            }
        }
    }
}

fileprivate enum OnboardingInfoType: String, Hashable, Identifiable, CaseIterable {
    public var id: String { self.rawValue }
    case intro
    case extensionInfo
    case restrictionInfo
    
    var desc: String {
        switch self {
        case .intro: "앱을 켤 때, 사용시간을\n설정해보세요."
        case .extensionInfo: "사용 시간이 지나면, 딱 2번,\n5분 더 사용할 수 있어요."
        case .restrictionInfo: "사용이 끝나면, 3분 동안\n앱을 절대 사용할 수 없어요."
        }
    }
}
