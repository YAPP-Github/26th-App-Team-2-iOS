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
import SharedDesignSystem
import SwiftUICore

public class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    private let appScheduleStorage: AppScheduleStorageProtocol = AppScheduleStorage()
    private let cooldownStorage: CooldownStorageProtocol = CooldownStorage()
    
    public override func configuration(shielding application: Application) -> ShieldConfiguration {
        let displayName = application.localizedDisplayName ?? "앱"
        
        return setShieldConfig(displayName)
    }
    
    public override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        guard let displayName = application.localizedDisplayName,
              let _ = category.localizedDisplayName else {
            return setShieldConfig("알 수 없는 앱")
        }
        return setShieldConfig(displayName)
    }
    
    public override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        guard let displayName = webDomain.domain else {
            return setShieldConfig("알 수 없는 웹사이트")
        }
        return setShieldConfig(displayName)
    }
    
    public override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        guard let displayName = webDomain.domain,
              let _ = category.localizedDisplayName else {
            return setShieldConfig("알 수 없는 웹사이트")
        }
        return setShieldConfig(displayName)
    }
    
    // MARK: - App Name Management
    
    private func setShieldConfig(_ tokenName: String) -> ShieldConfiguration {
        
        let status = getBlockingStatus(tokenName)
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
    
    private func getBlockingStatus(_ tokenName: String) -> BlockingStatus {
        let status = appScheduleStorage.getBlockingStatus() ?? .blocking(tokenName: tokenName)
        let validatedStatus: BlockingStatus = validateAndFixStatus(status, tokenName: tokenName)
        
        switch validatedStatus {
        case .blocking:
            return .blocking(tokenName: tokenName)
        case .unlockedTemporarily:
            return .unlockedTemporarily
        case .extensionPrompt(let time, let count, let startDate, let endDate):
            // 저장된 시간과 횟수를 그대로 사용
            return .extensionPrompt(time: time, count: count, startDate: startDate, endDate: endDate)
        case .sessionEnded(let time, let groupName):
            // 저장된 시간과 그룹명을 그대로 사용
            return .sessionEnded(time: time, groupName: groupName)
        case .cooldownActive(_, let time, let groupName):
            return .cooldownActive(tokenName: tokenName, time: time, groupName: groupName)
        }
    }
    
    /// 상태 검증 및 수정
    private func validateAndFixStatus(_ status: BlockingStatus, tokenName: String) -> BlockingStatus {
        switch status {
        case .cooldownActive:
            if !cooldownStorage.isInCooldown() {
                // 쿨다운이 종료되었는데 아직 cooldownActive 상태라면 기본 차단 상태로 변경
                appScheduleStorage.saveBlockingStatus(.blocking(tokenName: tokenName))
                return .blocking(tokenName: tokenName)
            }
        case .sessionEnded: startCooldownFromSessionEnd()
        default:
            break
        }
        
        return status
    }
    
    private func getIconImage(by status: BlockingStatus) -> UIImage {
        switch status {
        case .blocking:
            return UIImage(resource: .iconArrow)
        case .unlockedTemporarily:
            return UIImage(resource: .iconWarning)
        case .extensionPrompt(_, _, let startDate, let endDate):
            if .now < startDate.addingTimeInterval(60) { // "15분 더" 디자인
                return UIImage(resource: .illustrationTimer)
            } else if endDate < .now { // 쿨다운 시간을 넘음... blocking 화면을 보여줌...
                return UIImage(resource: .iconArrow)
            } else { // "쿨다운 시간"... 쿨다운 화면을 보여줌...
                return UIImage(resource: .illustrationBlock)
            }
        case .sessionEnded, .cooldownActive:
            return UIImage(resource: .illustrationBlock)
        }
    }
    
    /// 세션 종료 후 쿨다운 시작
    private func startCooldownFromSessionEnd() {
        let cooldownMinutes = appScheduleStorage.getExtensionTime()
        
        cooldownStorage.saveCooldownGroup(groupName: "앱 그룹")
        cooldownStorage.startCooldown(minutes: cooldownMinutes)
        
        // 쿨다운 상태로 변경
        // TODO: GroupName 받는 스토리지 필요
        appScheduleStorage.saveBlockingStatus(
            .cooldownActive(
                tokenName: "앱 그룹",
                time: cooldownMinutes,
                groupName: ""
            )
        )
    }
    
}

