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

    private enum CodingKeys: String, CodingKey {
        case documentTagId
        case textValue
        case checkboxValue
        case dateValue
    }

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

    /// Initializer.
    ///
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

    /// Initializer.
    ///
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

    /// Creates a new instance by decoding from the given decoder.
    /// This initializer throws an error if reading from the decoder fails, or
    /// if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameters:
    ///    - decoder: The decoder to read data from.
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        documentTagId = try container.decodeIfPresent(String.self, forKey: .documentTagId)
        textValue = try container.decodeIfPresent(String.self, forKey: .textValue)
        checkboxValue = try container.decodeIfPresent(Bool.self, forKey: .checkboxValue)

        if let dateString = try? container.decodeIfPresent(String.self, forKey: .dateValue),
           let date = Formatter.iso8601WithDateOnly.date(from: dateString) {
            dateValue = date
        }
        else {
            dateValue = nil
        }
    }

    /// Encodes this value into the given encoder.
    /// If the value fails to encode anything, `encoder` will encode an empty
    /// keyed container in its place.
    /// This function throws an error if any values are invalid for the given
    /// encoder's format.
    ///
    /// - Parameters:
    ///    - encoder: The encoder to write data to.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(documentTagId, forKey: .documentTagId)
        try container.encodeIfPresent(textValue, forKey: .textValue)
        try container.encodeIfPresent(checkboxValue, forKey: .checkboxValue)

        if let date = dateValue {
            try container.encodeIfPresent(Formatter.iso8601WithDateOnly.string(from: date), forKey: .dateValue)
        }
    }
}
