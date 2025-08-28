//
//  OnboardingInfoView.swift
//  FeatureOnboardingInterface
//
//  Created by Greem on 7/26/25.
//

import SwiftUI
import SharedDesignSystem



public struct OnboardingInfoView: View {
    
    @Environment(\.dismiss) var dismiss
    
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
        ZStack {
            Color.grey900.ignoresSafeArea()
            VStack(spacing: 0) {
                BrakeNavigationView(title: {
                    EmptyView()
                }, leading: {
//                    BrakeNavigationButton(type: .back) {
//                        dismiss()
//                    }
                    EmptyView()
                })
                TabView(selection: $selectedInfoType) {
                    ForEach(onboardinInfoTypes) { infoType in
                        VStack {
                                switch infoType {
                                case .extensionInfo:
                                    VStack(spacing: 24) {
                                        Image.onboarding.more
                                            .resizable()
                                            .aspectRatio(1, contentMode: .fit)
                                            .frame(width: 250)
                                            
                                        VStack(spacing: 0) {
                                            Text("사용 시간이 지나면, 딱 2번,")
                                            Text("5분 더 사용할 수 있어요.")
                                        }
                                        .font(.pretendard(size: 22, type: .semiBold))
                                        .foregroundStyle(.white)
                                    }
                                
                                case .intro:
                                    VStack(spacing: 24) {
                                        Image.onboarding.timeSetting
                                            .resizable()
                                            .aspectRatio(1, contentMode: .fit)
                                            .frame(width: 250)
                                        VStack(spacing: 0) {
                                            Text("앱을 켤 때, 사용 시간을")
                                            Text("설정해보세요.")
                                        }
                                        .font(.pretendard(size: 22, type: .semiBold))
                                        .foregroundStyle(.white)
                                    }
                                case .restrictionInfo:
                                    VStack(spacing: 24) {
                                        Image.onboarding.coolDown
                                            .resizable()
                                            .aspectRatio(1, contentMode: .fit)
                                            .frame(width: 250)
                                            
                                        VStack(spacing: 0) {
                                            Text("사용이 끝나면, 3분 동안")
                                            Text("앱을 절대 사용할 수 없어요.")
                                        }
                                        .font(.pretendard(size: 22, type: .semiBold))
                                        .foregroundStyle(.white)
                                    }
                                }
                            
                            Spacer()
                        }
                        .padding(.top, 37)
                        .tag(infoType)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .padding(.horizontal, 1)
                .padding(.bottom, 12)
                LargeButtonView(buttonType: .confirm, title: "확인", isActive: true) {
                        withAnimation {
                            switch selectedInfoType {
                            case .intro: self.selectedInfoType = .extensionInfo
                            case .extensionInfo: self.selectedInfoType = .restrictionInfo
                            case .restrictionInfo: infoCompleted()
                            }
                        }
                }
                .padding(.bottom, 16)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
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
