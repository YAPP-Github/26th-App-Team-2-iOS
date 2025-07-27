//
//  AllCustomButtonView.swift
//  SharedDesignSystemExample
//
//  Created by Derrick kim on 7/27/25.
//

import SwiftUI
import SharedDesignSystem

struct AllCustomButtonView: View {
    @State private var isActive = true

    var body: some View {
        DisclosureGroup("Buttons") {
            NavigationLink("LargeButtonView") {
                LargeButtonView_ex()
            }

            NavigationLink("SmallButtonView") {
                SmallButtonView_ex()
            }
        }
    }
}

#Preview {
    AllCustomButtonView()
}
