//
//  AnalyticsHeaderGenerator.swift
//  BoxSDK
//
//  Created by Daniel Cech on 09/05/2019.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation
#if os(iOS) || os(tvOS)
    import UIKit
#elseif os(watchOS)
    import WatchKit
#elseif os(OSX)
    import AppKit
#endif

/// Analytics info about the app using the SDK.
public struct ClientAnalyticsInfo {
    var appName: String
    var appVersion: String

    /// Initializer
    ///
    /// - Parameters:
    ///   - appName: Name of the app using the SDK.
    ///   - appVersion: Version of the app using the SDK.
    public init(appName: String, appVersion: String) {
        self.appName = appName
        self.appVersion = appVersion
    }
}

class AnalyticsHeaderGenerator {

    lazy var deviceName: String = {
        #if os(iOS) || os(tvOS)
            return UIDevice.current.modelName
        #elseif os(watchOS)
            return WKInterfaceDevice.current().model
        #elseif os(OSX)
            return "macOS"
        #endif
    }()

    lazy var iOSVersion: String = {
        #if os(iOS) || os(tvOS)
            return UIDevice.current.systemVersion
        #elseif os(watchOS)
            return WKInterfaceDevice.current().systemVersion
        #elseif os(OSX)
            let version = ProcessInfo.processInfo.operatingSystemVersion
            let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
            return versionString
        #endif
    }()

    lazy var swiftSDKVersion: String = {
        // swiftlint:disable:next force_unwrapping
        let dictionary = Bundle(for: type(of: self)).infoDictionary!
        // swiftlint:disable:next force_cast
        let version = dictionary["CFBundleShortVersionString"] as! String
        return version
    }()

    func analyticsHeader(forConfiguration configuration: BoxSDKConfiguration) -> String {
        var header = "agent=box-swift-sdk/\(swiftSDKVersion); env=\(deviceName)/\(iOSVersion)"

        if let clientAnalyticsInfo = configuration.clientAnalyticsInfo {
            header += "; client=\(clientAnalyticsInfo.appName)/\(clientAnalyticsInfo.appVersion)"
        }

        return header
    }
}
