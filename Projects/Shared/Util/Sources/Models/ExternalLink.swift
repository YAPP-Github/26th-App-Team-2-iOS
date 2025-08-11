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
    case appVersion

    public var id: String { title }

    public var url: String {
        switch self {
        case .privacyPolicy:
            return "https://www.notion.so/ahnsh/Brake-223b76e3040280438cc7ec812de68c0f?source=copy_link"
        case .termsOfService:
            return "https://ahnsh.notion.site/service"
        case .feedback:
            return "https://ahnsh.notion.site/245b76e304028092925dd625cd38ceeb"
        case .contactUs:
            return "https://ahnsh.notion.site/245b76e304028000ade7ec331648fecc"
        case .appVersion:
            return ""
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
        case .appVersion:
            return "앱 버전 정보"
        }
    }

}
