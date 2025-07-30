//
//  TappableText.swift
//  FeatureOnboardingInterface
//
//  Created by Greem on 7/30/25.
//

import Foundation
import SwiftUI

public struct TappableText: View {
    public let text: String
    public let tappableWords: [String: () -> Void]
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(words, id: \.self) { word in
                if tappableWords.keys.contains(word.trimmingCharacters(in: .whitespaces)) {
                    Button {
                        tappableWords[word]?()
                    } label: {
                        Text(word)
                            .underline()
                            .font(.pretendard(size: 12, type: .medium))
                            .foregroundStyle(Color.grey400)
                            
                    }
                } else {
                    Text(word)
                        .font(.pretendard(size: 12, type: .medium))
                        .foregroundStyle(Color.grey400)
                }
            }
        }
    }
    
    private var words: [String] {
        let res = text.components(separatedBy: " ").map { $0 + " " }.flatMap({ word in
            for tappableWord in tappableWords.keys {
                if word.contains(tappableWord) {
                    return [tappableWord,  String(word.split(separator: tappableWord)[0])]
                }
            }
            return [word]
        })
        return res
    }
}
