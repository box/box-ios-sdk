//
//  SignRequestPrefillTag.swift
//  BoxSDK-iOS
//
//  Created by Artur Jankowski on 08/10/2021.
//  Copyright © 2021 box. All rights reserved.
//

import Foundation

/// Prefill tags are used to prefill placeholders with signer input data.
/// Only one value field can be included.
public class SignRequestPrefillTag: BoxInnerModel {

    // MARK: - Properties

    /// This references the ID of a specific tag contained in a file of the sign request
    public let documentTagId: String?
    /// Text prefill value
    public let textValue: String?
    /// Checkbox prefill value
    public let checkboxValue: Bool?
    /// Date prefill value
    public let dateValue: Date?

    /// Initializer.
    ///
    /// - Parameters:
    ///   - documentTagId: Id of the tag.
    ///   - textValue: The text prefill value.
    public init(
        documentTagId: String?,
        textValue: String?
    ) {
        self.documentTagId = documentTagId
        self.textValue = textValue
        checkboxValue = nil
        dateValue = nil
    }

    /// - Parameters:
    ///   - documentTagId: Id of the tag.
    ///   - checkboxValue: The checkbox prefill value.
    public init(
        documentTagId: String?,
        checkboxValue: Bool?
    ) {
        self.documentTagId = documentTagId
        self.checkboxValue = checkboxValue
        textValue = nil
        dateValue = nil
    }

    /// - Parameters:
    ///   - documentTagId: Id of the tag.
    ///   - dateValue: The date prefill value.
    public init(
        documentTagId: String?,
        dateValue: Date?
    ) {
        self.documentTagId = documentTagId
        self.dateValue = dateValue
        textValue = nil
        checkboxValue = nil
    }
}
