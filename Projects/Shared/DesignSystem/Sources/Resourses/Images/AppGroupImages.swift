//
//  AppGroupImages.swift
//  SharedDesignSystem
//
//  Created by Greem on 7/31/25.
//


import SwiftUI

public protocol AppGroupImagesProtocol {
    static var appGroup: AppGroupImages { get }
}

extension AppGroupImagesProtocol {
    public static var appGroup: AppGroupImages { AppGroupImages() }
}

public struct AppGroupImages {
    public let mainEmpty: Image = SharedDesignSystemAsset.Images.appgroupMainEmpty.swiftUIImage
    public let mainFull: Image = SharedDesignSystemAsset.Images.appgroupMainList.swiftUIImage
    public let lockTimer: Image = SharedDesignSystemAsset.Images.appgroupLockTimer.swiftUIImage
    init() { }
}
