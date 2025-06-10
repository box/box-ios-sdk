//
//  MetadataModule.swift
//  BoxSDK-iOS
//
//  Created by Daniel Cech on 6/20/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// Defines methods for metadata management
public class MetadataModule {
    /// Required for communicating with Box APIs.
    weak var boxClient: BoxClient!
    // swiftlint:disable:previous implicitly_unwrapped_optional

    /// Initializer
    ///
    /// - Parameter boxClient: Required for communicating with Box APIs.
    init(boxClient: BoxClient) {
        self.boxClient = boxClient
    }
}
