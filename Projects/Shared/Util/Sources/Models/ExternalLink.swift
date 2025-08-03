//
//  ExternalLink.swift
//  SharedUtil
//
//  Created by Derrick kim on 8/3/25.
//

import Foundation

public enum ExternalLink: Identifiable {
    case feedback
    case contactUs
    case privacyPolicy
    case termsOfService

    public var id: String { title }

    public var url: String {
        switch self {
        case .privacyPolicy:
            return "https://www.notion.so/ahnsh/Brake-223b76e3040280438cc7ec812de68c0f?source=copy_link"
        case .termsOfService:
            return "https://ahnsh.notion.site/service"
        case .feedback:
            return "" //TODO: 추후 추가 예정
        case .contactUs:
            return "" //TODO: 추후 추가 예정
        }
    }

    public var title: String {
        switch self {
        case .privacyPolicy:
            return "개인정보 처리방침"
        case .termsOfService:
            return "이용약관"
        case .feedback:
            return "의견 남기기"
        case .contactUs:
            return "문의하기"
        }
    }

}
