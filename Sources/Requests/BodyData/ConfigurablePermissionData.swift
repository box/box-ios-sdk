//
//  ConfigurablePermissionData.swift
//  BoxSDK-iOS
//
//  Created by Cary Cheng on 9/4/19.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

/// Defines configurable permission data for creating and updating group membership.
/// Configurable Permission defines what the user of the groups have abilities to do.
public struct ConfigurablePermissionData: Encodable {

    /// Whether the user can run reports.
    public let canRunReports: Bool?
    /// Whether the user can instant login.
    public let canInstantLogin: Bool?
    /// Whether the user can create other accounts.
    public let canCreateAccounts: Bool?
    /// Whether the user can edit accounts.
    public let canEditAccounts: Bool?

    /// Initializer.
    ///
    /// - Parameters:
    ///   - canRunReports: Indicator for whether the admin can run reports.
    ///   - canInstantLogin: Indicator for whether the admin can instant login.
    ///   - canCreateAccounts: Indicator for whether the admin can create accounts.
    ///   - canEditAccounts: Indicator for whether the admin can edit accounts.
    public init(
        canRunReports: Bool? = nil,
        canInstantLogin: Bool? = nil,
        canCreateAccounts: Bool? = nil,
        canEditAccounts: Bool? = nil
    ) {
        self.canRunReports = canRunReports
        self.canInstantLogin = canInstantLogin
        self.canCreateAccounts = canCreateAccounts
        self.canEditAccounts = canEditAccounts
    }
}
