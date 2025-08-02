//
//  OpenAppUseCase.swift
//  DomainScreenTimeManagement
//
//  Created by Derrick kim on 7/31/25.
//

import DomainScreenTimeManagementInterface
import UIKit

/// 차단 화면에서 메인 앱을 여는 UseCase
/// - 사용처: ShieldActionConfigurationExtension에서 "남은 시간 확인" 버튼을 눌렀을 때
/// - 기능: URL Scheme을 통해 메인 앱을 열어 사용자가 상세 정보를 확인할 수 있도록 함
public struct OpenAppUseCase: OpenAppUseCaseProtocol {
    
    public init() {}
    
    public func execute() {
        // URL Scheme을 통해 앱 열기
        if let url = URL(string: "brake://") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
} 
