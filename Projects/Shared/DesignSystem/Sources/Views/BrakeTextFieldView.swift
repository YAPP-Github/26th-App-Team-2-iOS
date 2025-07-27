//
//  BrakeTextFieldView.swift
//  SharedDesignSystem
//
//  Created by Derrick kim on 7/27/25.
//

import SwiftUI

public struct BrakeTextFieldView: View {

    @Binding private var text: String
    private let placeholder: String
    private let maxLength: Int
    private let regex: String?
    private let topDescription: String?
    private let bottomDescription: String?
    private let descriptionPosition: DescriptionPosition

    public enum DescriptionPosition {
        case top
        case bottom
        case none
    }

    @State private var isValid: Bool = false
    @State private var hasError: Bool = false

    public init(
        text: Binding<String>,
        placeholder: String,
        maxLength: Int = 10,
        regex: String? = nil,
        topDescription: String? = nil,
        bottomDescription: String? = nil,
        descriptionPosition: DescriptionPosition = .none
    ) {
        self._text = text
        self.placeholder = placeholder
        self.maxLength = maxLength
        self.regex = regex
        self.topDescription = topDescription
        self.bottomDescription = bottomDescription
        self.descriptionPosition = descriptionPosition
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 상단 Description (위쪽에 표시)
            if descriptionPosition == .top,
               let topDescription = topDescription, !text.isEmpty {
                TextFieldDescriptionView(
                    descriptionText: topDescription,
                    count: text.count,
                    maxLength: maxLength,
                    isTop: true
                )
            }

            // 텍스트 필드
            ZStack(alignment: .trailing) {
                TextField(
                    "",
                    text: $text,
                    prompt: Text(placeholder)
                        .foregroundColor(Colors.grey400.swiftUIColor)
                )
                .font(.pretendard(size: 16, type: .medium))
                .tint(Colors.white.swiftUIColor) // 커서 색상
                .foregroundStyle(Colors.white.swiftUIColor) // 입력된 텍스트 색
                .frame(height: 52)
                .padding(.horizontal, 16)
                .background(Colors.grey850.swiftUIColor)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .onChange(of: text) { _, newValue in
                    validateText(newValue)
                }

                // 성공/실패 상태 표시 (텍스트 필드 내부 오른쪽)
                if let _ = regex {
                    HStack {
                        Spacer()
                        if isValid {
                            Images.iconCheck.swiftUIImage
                                .frame(width: 24, height: 24)
                        }
                    }
                    .padding(.trailing, 16)
                }
            }

            if descriptionPosition == .bottom,
               let bottomDescription = bottomDescription {
                TextFieldDescriptionView(
                    descriptionText: bottomDescription,
                    count: text.count,
                    maxLength: maxLength,
                    hasError: $hasError,
                    isTop: false
                )
            }
        }
        .background(Color.black)
        .onAppear {
            validateText(text)
        }
    }

    private func validateText(_ inputText: String) {
        guard let regex = regex else { return }

        // 최대 길이 제한
        if inputText.count > maxLength {
            text = String(inputText.prefix(maxLength))
            return
        }

        // 정규식 검증
        let regexPattern = try? NSRegularExpression(pattern: regex)
        let range = NSRange(location: 0, length: inputText.utf16.count)

        if let regexPattern = regexPattern {
            let matches = regexPattern.matches(in: inputText, range: range)
            isValid = !matches.isEmpty && inputText.count > 0
            hasError = inputText.count > 0 && !isValid
        }
    }
}

fileprivate struct TextFieldDescriptionView: View {

    @State private var descriptionText: String
    @State private var count: Int
    @State private var maxLength: Int
    @Binding private var hasError: Bool
    @State private var isTop: Bool

    init(
        descriptionText: String,
        count: Int = 0,
        maxLength: Int = 10,
        hasError: Binding<Bool>? = nil,
        isTop: Bool
    ) {
        self.descriptionText = descriptionText
        self.count = count
        self.maxLength = maxLength
        self._hasError = hasError ?? .constant(false)
        self.isTop = isTop
    }

    var body: some View {
        HStack {
            Text(descriptionText)
                .font(.pretendard(size: isTop ? 14 : 12, type: .medium))
                .foregroundStyle(textColor)

            Spacer()

            if isTop {
                HStack(spacing: 0) {
                    Text("\(count)")
                        .font(.pretendard(size: 12, type: .medium))
                        .foregroundStyle(Colors.white.swiftUIColor)
                    Text("/")
                        .font(.pretendard(size: 12, type: .medium))
                        .foregroundStyle(textColor)
                    Text("\(maxLength)")
                        .font(.pretendard(size: 12, type: .medium))
                        .foregroundStyle(textColor)
                }
            } else {
                Text("\(count)/\(maxLength)")
                    .font(.pretendard(size: 12, type: .medium))
                    .foregroundStyle(textColor)
            }
        }
        .padding([.leading, .trailing], 16)
    }

    private var textColor: Color {
        if isTop {
            return Colors.grey400.swiftUIColor
        } else {
            if hasError {
                return Colors.error.swiftUIColor
            } else {
                return Colors.guideGreen.swiftUIColor
            }
        }
    }
}
