//
//  AppDIContainer.swift
//  Brake
//
//  Created by Derrick kim on 2025/08/05.
//

import SwiftUI
import Domain
import Core
import SharedUtil
import FeatureOnboardingInterface


public protocol AppDIContainerProtocol {
    // MARK: - Core Layer
    var coreContainer: CoreDIContainerProtocol { get }
    var serviceContainer: ServiceDIContainerProtocol { get }
    var useCaseContainer: UseCaseDIContainerProtocol { get }
}

public final class AppDIContainer: AppDIContainerProtocol {
    public init() {}

    public lazy var coreContainer: CoreDIContainerProtocol = CoreDIContainer()
    public lazy var serviceContainer: ServiceDIContainerProtocol = ServiceDIContainer(coreContainer: coreContainer)
    public lazy var useCaseContainer: UseCaseDIContainerProtocol = UseCaseDIContainer(
        serviceContainer: serviceContainer,
        coreContainer: coreContainer
    )

}

private struct AppDIContainerKey: EnvironmentKey {
    static let defaultValue: AppDIContainerProtocol = AppDIContainer()
}

extension EnvironmentValues {
    public var appDIContainer: AppDIContainerProtocol {
        get { self[AppDIContainerKey.self] }
        set { self[AppDIContainerKey.self] = newValue }
    }
} 
