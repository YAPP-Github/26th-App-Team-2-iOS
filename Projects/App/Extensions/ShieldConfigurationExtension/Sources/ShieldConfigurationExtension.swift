//
//  ShieldConfigurationExtension.swift
//  Brake
//
//  Created by Derrick kim on 7/11/25.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit
import CoreLocalStorageInterface
import CoreLocalStorage

public class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    private let appScheduleStorage: AppScheduleStorageProtocol = AppScheduleStorage()

    public override func configuration(shielding application: Application) -> ShieldConfiguration {
        let displayName = application.localizedDisplayName ?? "앱"
        return setShieldConfig(displayName)
    }

    public override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        guard let displayName = application.localizedDisplayName,
              let categoryName = category.localizedDisplayName else {
            return setShieldConfig("알 수 없는 앱")
        }
        return setShieldConfig("\(categoryName) - \(displayName)")
    }

    public override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        guard let displayName = webDomain.domain else {
            return setShieldConfig("알 수 없는 웹사이트")
        }
        return setShieldConfig(displayName)
    }

    public override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        guard let displayName = webDomain.domain,
              let categoryName = category.localizedDisplayName else {
            return setShieldConfig("알 수 없는 웹사이트")
        }
        return setShieldConfig("\(categoryName) - \(displayName)")
    }

    private func setShieldConfig(_ tokenName: String) -> ShieldConfiguration {
        let status = appScheduleStorage.getBlockingStatus() ?? .blocking(tokenName: tokenName)
        let customIcon = getIconImage(by: status)
        let customTitle = ShieldConfiguration.Label(
            text: status.title,
            color: .white
        )

        let customPrimaryButtonLabel: ShieldConfiguration.Label?
        let primaryButton = ShieldConfiguration.Label(
            text: status.primaryButtonTitle,
            color: .black
        )
        switch status {
        case .unlockedTemporarily:
            customPrimaryButtonLabel = nil
        default:
            customPrimaryButtonLabel = primaryButton
        }

        let customSecondaryButtonLabel = ShieldConfiguration.Label(
            text: status.secondaryButtonTitle,
            color: .lightGray
        )

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

    private func getIconImage(by status: BlockingStatus) -> UIImage {
        switch status {
        case .blocking:
            return UIImage(resource: .iconArrow)
        case .unlockedTemporarily:
            return UIImage(resource: .iconWarning)
        case .extensionPrompt:
            return UIImage(resource: .illustrationBlock)
        case .cooldownActive, .blockedAfterExtension:
            return UIImage(resource: .illustrationBlock)
        }
    }
}
