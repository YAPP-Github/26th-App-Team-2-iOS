//
//  BrakeTabBarView.swift
//  SharedDesignSystem
//
//  Created by Derrick kim on 7/27/25.
//

import SwiftUI

public struct BrakeTabBarView: View {

    @Binding private var selectedTabBarItem: TabItemType

    public init(selectedTabBarItem: Binding<TabItemType>) {
        self._selectedTabBarItem = selectedTabBarItem
    }

    public var body: some View {
        HStack(spacing: 48) {
            ForEach(TabItemType.allCases) { item in
                Button {
                    selectedTabBarItem = item
                } label: {
                    VStack(spacing: 2) {
                        item.iconImage
                            .foregroundStyle(selectedTabBarItem == item ? Color.brakeWhite : Color.grey700)
                            .frame(width: 28, height: 28)

                        Text(item.title)
                            .font(.pretendard(size: 12, type: .medium))
                            .foregroundStyle(selectedTabBarItem == item ? Color.brakeWhite : Color.grey700)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 48)
        .padding(.vertical, 16)
        .background(Color.grey800)
        .clipShape(RoundedRectangle(cornerRadius: 60))
    }
}
