//
//  MetadataFieldFilter.swift
//  BoxSDK
//
//  Created by Sujay Garlanka on 9/26/19.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

/// Filter for matching against a metadata field
public struct MetadataFieldFilter: BoxInnerModel {

    // MARK: - Properties

    /// The field to match against.
    public let field: String
    /// The value to match against.
    public let value: String

    /// Initializer.
    ///
    /// - Parameters:
    ///   - field: The field to match against.
    ///   - value: The value to match against.
    public init(
        field: String,
        value: String
    ) {
        self.field = field
        self.value = value
    }
}
