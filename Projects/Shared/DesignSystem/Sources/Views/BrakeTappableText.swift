//
//  BrakeTappableText.swift
//  FeatureOnboardingInterface
//
//  Created by Greem on 7/30/25.
//

import Foundation
import SwiftUI

public struct BrakeTappableText: View {
    private let text: String
    private let tappableWords: [String: () -> Void]
    public init(
        text: String,
        tappableWords: [String : () -> Void]
    ) {
        self.text = text
        self.tappableWords = tappableWords
    }
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
                    let splitWords = word.split(separator: tappableWord)
                    if splitWords.count > 1 {
                        return [tappableWord,  String(splitWords[0])]
                    } else {
                        return [tappableWord]
                    }
                }
            }
            return [word]
        })
        return res
    }
}
