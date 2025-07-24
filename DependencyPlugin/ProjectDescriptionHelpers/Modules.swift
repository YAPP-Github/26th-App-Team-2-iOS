//
//  Modules.swift
//  26th-App-Team-2-iOSManifests
//
//  Created by Greem on 6/18/25.
//

import Foundation
import ProjectDescription

public enum ModulePath {
    case feature(Feature)
    case domain(Domain)
    case core(Core)
    case shared(Shared)
}

// MARK: AppModule

public extension ModulePath {
    /// 이 앱이 구동될 디바이스에 대한 정의를 합니다.
    enum App: String, CaseIterable {
        public static let name: String = "App"
        case iOS
        case NotificationExtension
        case DeviceActivityMonitorExtension
        case ShieldConfigurationExtension
        case ShieldActionConfigurationExtension
    }
}


// MARK: FeatureModule
public extension ModulePath {
    enum Feature: String, CaseIterable {
        public static let name: String = "Feature"
        
        case Onboarding
    }
}

// MARK: DomainModule

public extension ModulePath {
    enum Domain: String, CaseIterable {
        case OAuth
        public static let name: String = "Domain"
        
        case User
    }
}

// MARK: CoreModule

public extension ModulePath {
    enum Core: String, CaseIterable {
        public static let name: String = "Core"
        
        case Network
        case LocalStorage
        case AppScreenTime
    }
}

// MARK: SharedModule

public extension ModulePath {
    enum Shared: String, CaseIterable {
        
        public static let name: String = "Shared"
        
        case Util
        case ThirdParty
        case DesignSystem
    }
}


