//
//  SourceFileList+Template.swift
//  ProjectDescriptionHelpers
//
//  Created by Greem on 6/22/25.
//

import ProjectDescription

/// SourceFilesList는 Tuist에서 프로젝트의 소스 파일들을 관리하고 구성하는 타입입니다.
/// 주요 특징 및 사용 목적:
/// • 프로젝트 내의 소스 코드 파일들의 경로 패턴을 정의하여 타겟에 포함시킬 파일들을 지정합니다.
/// • glob 패턴을 사용하여 여러 파일을 한 번에 지정할 수 있습니다. (예: "Sources/**")
/// • 특정 파일이나 디렉토리를 제외하거나 포함시키는 필터링이 가능합니다.
/// • 프로젝트의 소스 코드 구조를 체계적으로 관리하고 빌드 시 필요한 파일들을 명확하게 정의합니다.

/// Tuist에서 SourceFilesList는 소스 파일 경로를 지정할 때 사용하는 타입이며,
/// 경로의 기준(최상위 경로)는 Project.swift 파일이 위치한 디렉터리입니다.
/// 즉, 상대 경로로 지정할 경우 Project.swift가 기준점(root)입니다.

public extension SourceFilesList {
    static let interface: SourceFilesList = "Interface/Sources/**"
    static let sources: SourceFilesList = "Sources/**"
    static let exampleSources: SourceFilesList = "Example/Sources/**"
    static let testing: SourceFilesList = "Testing/Sources/**"
    static let tests: SourceFilesList = "Tests/Sources/**"
    static let notificationExtensionSources : SourceFilesList = "Extensions/NotificationExtension/Sources/**"
    static let deviceActivityMonitorExtensionSources : SourceFilesList = "Extensions/DeviceActivityMonitorExtension/Sources/**"
    static let shieldConfigurationExtensionSources : SourceFilesList = "Extensions/ShieldConfigurationExtension/Sources/**"
    static let shieldActionConfigurationExtensionSources : SourceFilesList = "Extensions/ShieldActionConfigurationExtension/Sources/**"
    static let coreAppScreenTimeExampleSources : SourceFilesList = "Core/AppScreenTime/Example/Sources/**"
}
