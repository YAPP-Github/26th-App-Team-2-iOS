//
//  TappableText_ex.swift
//  SharedDesignSystemExample
//
//  Created by Greem on 8/2/25.
//

import SwiftUI
import SharedDesignSystem

struct TappableText_ex: View {
    private enum ColorOn {
        case red
        case yellow
        case blue
        var color: Color {
            switch self {
            case .yellow: .yellow
            case .blue: .blue
            case .red: .red
            }
        }
    }
    @State private var setColor: ColorOn = .yellow
    
    var body: some View {
        ZStack {
            setColor.color
            BrakeTappableText(text: "안녕하세요 모두 반가워요", tappableWords: [
                "안녕하세요": {
                    setColor = .red
                },
                "모두": {
                    setColor = .blue
                }
            ])
        }
        
    }
}
