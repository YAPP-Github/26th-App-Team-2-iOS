//
//  ShieldConfigurationExtension.swift
//  Brake
//
//  Created by Derrick kim on 7/11/25.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit

import SharedDesignSystem
import Core
import DomainScreenTimeManagementInterface
import DomainScreenTimeManagement

public class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    private let getBlockingStatusUseCase: GetBlockingStatusUseCaseProtocol
    
    override init() {
        print("ShieldConfigurationExtension 불림!!")
        let container = DIContainer()
        self.getBlockingStatusUseCase = container.makeGetBlockingStatusUseCase()
        super.init()
    }

    public override func configuration(shielding application: Application) -> ShieldConfiguration {
        print("🔐 ShieldConfigurationExtension - beginRequest called")
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
        let status = getBlockingStatusUseCase.execute(tokenName: tokenName)
        let customIcon = getIconImage(by: status)
        let titleLabel = ShieldConfiguration.Label(
            text: status.title,
            color: SharedDesignSystemAsset.Colors.grey100.color
        )
        let subtitleLabel = ShieldConfiguration.Label(
            text: status.subtitle,
            color: SharedDesignSystemAsset.Colors.grey300.color
        )

        let customPrimaryButtonLabel: ShieldConfiguration.Label?
        let primaryButton = ShieldConfiguration.Label(
            text: status.primaryButtonTitle,
            color: SharedDesignSystemAsset.Colors.grey850.color
        )
        switch status {
        case .unlockedTemporarily:
            customPrimaryButtonLabel = nil
        default:
            customPrimaryButtonLabel = primaryButton
        }

        let customSecondaryButtonLabel = ShieldConfiguration.Label(
            text: status.secondaryButtonTitle,
            color: SharedDesignSystemAsset.Colors.grey200.color
        )

        let shieldConfiguration = ShieldConfiguration(
            backgroundBlurStyle: .dark,
            backgroundColor: UIColor(red: 0.13, green: 0.14, blue: 0.16, alpha: 1.0),
            icon: customIcon,
            title: titleLabel,
            subtitle: subtitleLabel,
            primaryButtonLabel: customPrimaryButtonLabel,
            primaryButtonBackgroundColor: SharedDesignSystemAsset.Colors.buttonYellow.color,
            secondaryButtonLabel: customSecondaryButtonLabel
        )
        return shieldConfiguration
    }

    private func getIconImage(by status: BlockingStatusEntity) -> UIImage {
        switch status {
        case .blocking:
            return UIImage(resource: .iconArrow)
        case .unlockedTemporarily:
            return UIImage(resource: .iconWarning)
        case .extensionPrompt:
            return UIImage(resource: .illustrationBlock)
        case .sessionEnded, .cooldownActive:
            return UIImage(resource: .illustrationBlock)
        }
    }
}
