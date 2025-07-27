//
//  SmallButtonView_ex.swift
//  SharedDesignSystemExample
//
//  Created by Derrick kim on 7/27/25.
//

import SwiftUI
import SharedDesignSystem

struct SmallButtonView_ex: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("SmallButtonView Examples")
                .font(.headline)
                .padding(.top)
            
            Text("SmallButtonView는 아직 구현되지 않았습니다.")
                .font(.body)
                .foregroundStyle(Colors.grey700.swiftUIColor)
            
            Spacer()
        }
        .padding()
        .navigationTitle("SmallButtonView Example")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SmallButtonView_ex()
    }
}
