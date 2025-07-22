//
//  ShieldConfigurationExtension.swift
//  CoreAppScreenTime
//
//  Created by Derrick kim on 7/11/25.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit
import CoreAppScreenTimeInterface
import CoreLocalStorageInterface
import CoreLocalStorage

public class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    private let appGroupsStorage: AppGroupsStorageProtocol = AppGroupsStorage()

    public override func configuration(shielding application: Application) -> ShieldConfiguration {
        let displayName = application.localizedDisplayName ?? "앱"
        return setShieldConfig(displayName)
    }

    public override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for applications shielded because of their category.
        guard let displayName = application.localizedDisplayName,
              let categoryName = category.localizedDisplayName else {
            return setShieldConfig("알 수 없는 앱")
        }
        return setShieldConfig("\(categoryName) - \(displayName)")
    }

    public override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        // Customize the shield as needed for web domains.
        guard let displayName = webDomain.domain else {
            return setShieldConfig("알 수 없는 웹사이트")
        }
        return setShieldConfig(displayName)
    }

    public override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for web domains shielded because of their category.
        guard let displayName = webDomain.domain,
              let categoryName = category.localizedDisplayName else {
            return setShieldConfig("알 수 없는 웹사이트")
        }
        return setShieldConfig("\(categoryName) - \(displayName)")
    }

    private func isNotificationArrived() -> Bool {
        // AppGroupsStorage를 사용하여 알림 상태 확인
        return appGroupsStorage.getBlockingStatus()
    }

    private func setShieldConfig(_ tokenName: String) -> ShieldConfiguration {
        let isNotiArrived = isNotificationArrived()

        let customIcon = UIImage(resource: isNotiArrived ? .iconArrow : .iconWarning)
        let customTitle = ShieldConfiguration.Label(
            text: isNotiArrived ? "알림을 눌러 사용 시간을 설정해주세요" : "\(tokenName)을 꼭 사용하실건가요?",
            color: .white
        )
        let customSecondaryButtonLabel = ShieldConfiguration.Label(
            text: isNotiArrived ? "다시 알림 보내기" : "안하기",
            color: .lightGray
        )

        let topButton = ShieldConfiguration.Label(
            text: "사용하기",
            color: .black
        )
        let customPrimaryButtonLabel: ShieldConfiguration.Label? = isNotiArrived ? nil :topButton

        let shieldConfiguration = ShieldConfiguration(
            backgroundBlurStyle: .dark,
            backgroundColor: UIColor(red: 0.13, green: 0.14, blue: 0.16, alpha: 1.0),
            icon: customIcon,
            title: customTitle,
            subtitle: ShieldConfiguration.Label(text: "", color: .black),
            primaryButtonLabel: customPrimaryButtonLabel,
            primaryButtonBackgroundColor: UIColor.white,
            secondaryButtonLabel: customSecondaryButtonLabel
        )
        return shieldConfiguration
    }
}

 
