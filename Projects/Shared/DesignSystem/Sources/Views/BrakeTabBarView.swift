//
//  BrakeTabBarView.swift
//  SharedDesignSystem
//
//  Created by Derrick kim on 7/27/25.
//

import SharedDesignSystem
import SwiftUI

public struct BrakeTabBarView: View {

    @Binding public var selectedTabBarItem: TabItemType

    public init(selectedTabBarItem: Binding<TabItemType>) {
        self._selectedTabBarItem = selectedTabBarItem
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItemType.allCases) { item in
                Button {
                    selectedTabBarItem = item
                } label: {
                    VStack(spacing: 2) {
                        item.iconImage
                            .foregroundStyle(selectedTabBarItem == item ? Colors.white.swiftUIColor : Colors.grey700.swiftUIColor)
                            .frame(width: 28, height: 28)

                        Text(item.title)
                            .font(.pretendard(size: 12, type: .medium))
                            .foregroundStyle(selectedTabBarItem == item ? Colors.white.swiftUIColor : Colors.grey700.swiftUIColor)
                    }
                }
                .frame(maxWidth: .infinity)
                .buttonStyle(.plain)
            }
        }
        .frame(width: 279, height: 80)
        .background(Colors.grey800.swiftUIColor)
        .clipShape(RoundedRectangle(cornerRadius: 60))
    }
}
