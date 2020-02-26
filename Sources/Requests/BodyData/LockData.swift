//
//  LockData.swift
//  BoxSDK-iOS
//
//  Created by Matthew Willer on 7/30/19.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

/// Defines a lock on a Box item
public struct LockData: Encodable {

    /// Resource type
    let type = "lock"

    /// When the lock should expire
    let expiresAt: Date?

    /// Whether or not the file can be downloaded while locked
    let isDownloadPrevented: Bool?

    /// Initializer.
    ///
    /// - Parameters:
    ///   - expiresAt: When the lock should expire
    ///   - isDownloadPrevented: Whether or not the file can be downloaded while locked
    public init(expiresAt: Date?, isDownloadPrevented: Bool?) {
        self.expiresAt = expiresAt
        self.isDownloadPrevented = isDownloadPrevented
    }
}
