//
//  MetadataField.swift
//  BoxSDK
//
//  Created by Daniel Cech on 20/06/2019.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

/// A field in a metadata template.
public struct MetadataField: BoxInnerModel {

    // MARK: - Properties

    /// Identfier
    public let id: String?
    /// The data type of the field's value.
    public let type: String?
    /// A unique identifier for the field. The identifier must be unique within the template to which it belongs.
    public let key: String?
    /// The display name of the field.
    public let displayName: String?
    /// A description of the field.
    public let description: String?
    /// For type enum, a list of all possible value
    public let options: [[String: String]]?
    /// Whether this template is hidden in the UI
    public let hidden: Bool?

    /// Initializer.
    ///
    /// - Parameters:
    ///   - id: Identfier
    ///   - type: The data type of the field's value.
    ///   - key: A unique identifier for the field. The identifier must be unique within the template to which it belongs.
    ///   - displayName: The display name of the field. All characters are allowed.
    ///   - description: A description of the field. The recommended character limit is 4096. All characters are allowed.
    ///   - options: For type enum, a list of all possible values.
    ///   - hidden: Whether this template is hidden in the UI.
    public init(
        id: String? = nil,
        type: String? = nil,
        key: String? = nil,
        displayName: String? = nil,
        description: String? = nil,
        options: [[String: String]]? = nil,
        hidden: Bool? = nil
    ) {
        self.id = id
        self.type = type
        self.key = key
        self.displayName = displayName
        self.description = description
        self.options = options
        self.hidden = hidden
    }
}
