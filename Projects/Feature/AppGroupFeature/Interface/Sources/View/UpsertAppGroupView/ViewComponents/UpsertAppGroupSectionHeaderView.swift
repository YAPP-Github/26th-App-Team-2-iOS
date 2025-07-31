//
//  UpsertAppGroupSectionHeaderView.swift
//  FeatureAppGroupFeatureInterface
//
//  Created by Greem on 7/29/25.
//

import Foundation
import SwiftUI

extension UpsertAppGroupView{
    struct UpsertAppGroupSectionHeaderView: View {
        let title: String
        let highlightDesc: String
        let description: String
        var body: some View {
            HStack(alignment: .firstTextBaseline) {
                Text(title)
                    .foregroundStyle(Color.grey200)
                    .font(.pretendard(size: 14, type: .medium))
                    .padding(.leading, 16)
                Spacer()
                (
                    Text(highlightDesc).foregroundStyle(Color.brakeWhite)
                    +
                    Text(description).foregroundStyle(Color.grey200)
                )
                .font(.pretendard(size: 12, type: .medium))
                .padding(.trailing, 16)
            }
        }
    }
    
}
