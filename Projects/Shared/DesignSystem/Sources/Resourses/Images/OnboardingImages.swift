//
//  OnboardingImages.swift
//  SharedDesignSystem
//
//  Created by Greem on 7/31/25.
//

import Foundation
import SwiftUI

public protocol OnboardingImagesProtocol {
    static var onboarding: OnboardingImages { get }
}
extension OnboardingImagesProtocol {
    public static var onboarding: OnboardingImages { OnboardingImages() }
}

public struct OnboardingImages {
    public let coolDown: Image = SharedDesignSystemAsset.Images.onboardingCooldown.swiftUIImage
    public let more: Image = SharedDesignSystemAsset.Images.onboardingMore.swiftUIImage
    public let timeSetting: Image = SharedDesignSystemAsset.Images.onboardingTimeSetting.swiftUIImage
    public let screentime: Image = SharedDesignSystemAsset.Images.onboardingAuthScreentime.swiftUIImage
    public let notification: Image = SharedDesignSystemAsset.Images.onboardingAuthNotification.swiftUIImage
    
    init() { }
}
