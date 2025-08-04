//
//  AppGroupMainGroupListCell.swift
//  FeatureAppGroupFeature
//
//  Created by Greem on 7/30/25.
//

import Foundation
import SwiftUI
import SharedDesignSystem
import Domain

enum BrakeStatus: Int {
    case session
    case locked
    case none
}

extension AppGroupMainView {
    struct AppGroupListCell: View {
        @Environment(AppGroupMainViewModel.self) var appGroupViewModel
        let appGroup: AppGroup
        
        let editButtonTapped: () -> ()
        let sessionExitButtonTapped: () -> ()
        
        
        var body: some View {
            VStack(spacing: 20) {
                VStack(spacing: 12) {
                    HStack {
                        HStack {
                            if appGroupViewModel.currentActiveAppGroup?.groupID == appGroup.groupID {
                                switch appGroupViewModel.brakeStatus {
                                case .none: Image.iconGroupSetting
                                case .session:
                                    Image.iconGroupTimer
                                case .locked:
                                    Image.iconGroupCoolDown
                                }
                            } else {
                                Image.iconGroupSetting
                            }
                            Text(appGroup.name)
                                .font(.pretendard(size: 16, type: .medium))
                        }
                        .foregroundStyle(Color.grey00)
                        Spacer()
                        Button {
                            editButtonTapped()
                        } label: {
                            Image.iconCircleEdit
                        }.disabled(
                            appGroupViewModel.brakeStatus != .none
                        )
                    }
                    
                    HStack(spacing: 0) {
                        let allApplicationTokensCount = appGroup.selection.applicationTokens.count
                        let infoApplicationTokens = appGroup.selection.applicationTokens.map { $0 }.prefix(6)
                        ForEach(infoApplicationTokens, id: \.hashValue) { applicationToken in
                            Label(applicationToken)
                                .labelStyle(.iconOnly)
                                .scaleEffect(1.2)
                        }
                        
                        if allApplicationTokensCount > 6 {
                            let restCount = allApplicationTokensCount - 6
                            Text("+\(restCount)")
                                .font(.pretendard(size: 14, type: .medium))
                                .foregroundStyle(Color.grey200)
                        }
                        Spacer()
                    }.padding(.leading, 8)
                }
                if appGroupViewModel.currentActiveAppGroup?.groupID == appGroup.groupID {
                    switch appGroupViewModel.brakeStatus {
                    case .none: EmptyView()
                    case .session:
                        Rectangle().fill(Color.grey800).frame(height: 1)
                        VStack(spacing: 27) {
                            BrakeTimerView(
                                lineWidth: 7,
                                progress: appGroupViewModel.sessionRestRatio,
                                startColor: Color(hex: "#B6C1E0"),
                                endColor: Color.brakeYellow
                            ) {
                                SessionTimerTextView(
                                    minutes: appGroupViewModel.sessionRestTime / 60,
                                    seconds: appGroupViewModel.sessionRestTime % 60
                                )
                            }
                            .padding(.top, 12)
                            .padding(.horizontal, 18)
                            Button {
                                sessionExitButtonTapped()
                            } label: {
                                HStack(spacing: 5) {
                                    Image.iconExit
                                    Text("사용종료")
                                }
                                .foregroundStyle(Color.grey00)
                                .tint(Color.grey00)
                                .font(.pretendard(size: 14, type: .semiBold))
                                .padding(.horizontal, 27.5)
                                .padding(.vertical, 14.5)
                                .background(Color.grey900)
                                .clipShape(Capsule())
                            }
                            
                        }
                    case .locked:
                        Rectangle().fill(Color.grey800).frame(height: 1)
                        VStack(spacing: 27) {
                            BrakeTimerView(
                                lineWidth: 7,
                                progress: appGroupViewModel.sessionRestRatio,
                                startColor: Color(hex: "#B6C1E0"),
                                endColor: Color.brakeYellow
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
                            .padding(.top, 12)
                            .padding(.horizontal, 18)
                            
                        }.padding(.bottom, 28)
                    }
                }
                
            }
            .padding([.top, .horizontal], 16)
            .padding(.bottom, 24)
            .background {
                LinearGradient(
                    colors: [
                        Color(hex: "#292C31"),
                        Color(hex: "#32363B")
                    ],
                    startPoint: UnitPoint(x: 0.4, y: 0),
                    endPoint: UnitPoint(x: 0.6,y: 1)
                )
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}


fileprivate struct SessionTimerTextView: View {
    let minutes: Int
    let seconds: Int
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("남은 사용 시간")
                .foregroundStyle(Color.grey400)
                .font(.pretendard(size: 14, type: .medium))
                .multilineTextAlignment(.center)
                .frame(height: 21)
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
}
