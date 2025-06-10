//
//  FolderUploadEmail.swift
//  BoxSDK
//
//  Created by Abel Osorio on 5/27/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// Defines upload email address for a folder.
public class FolderUploadEmail: BoxInnerModel {
    // MARK: - Properties

    /// Access level
    public let access: String?
    /// Email addresss
    public let email: String?
}
