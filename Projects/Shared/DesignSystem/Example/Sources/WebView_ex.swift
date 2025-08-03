//
//  WebView_ex.swift
//  SharedDesignSystemExample
//
//  Created by Greem on 8/2/25.
//

import SwiftUI
import SharedDesignSystem

struct WebView_ex: View {
    @State var isOn: Bool = false
    var body: some View {
        
        Button {
            isOn.toggle()
        } label: {
            Text("네이버 가기")
        }.fullScreenCover(isPresented: $isOn) {
            NavigationStack {
                BrakeWebView(url: URL(string: "https://www.naver.com")!)
                    .navigationTitle("네이버 띄우기")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                isOn = false
                            } label: {
                                Text("닫아버려")
                            }

                        }
                    }
            }
        }

        
    }
}
