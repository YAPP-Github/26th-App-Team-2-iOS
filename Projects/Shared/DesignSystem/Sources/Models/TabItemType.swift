//
//  TabItemType.swift
//  SharedDesignSystem
//
//  Created by Derrick kim on 7/27/25.
//

import SwiftUI

public enum TabItemType: String, CaseIterable, Identifiable {
//    case report
    case dashboard
    case myInfo

    public var id: Self { self }

    public var title: String {
        switch self {
//        case .report:       return "리포트"
        case .dashboard:    return "관리"
        case .myInfo:       return "내 정보"
        }
    }

    public var iconImage: Image {
        switch self {
//        case .report:       return Image.iconReport.renderingMode(.template)
        case .dashboard:    return Image.iconDashboard.renderingMode(.template)
        case .myInfo:       return Image.iconMyInfo.renderingMode(.template)
        }
    }
}
