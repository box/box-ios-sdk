//
//  SignRequestSignerInput.swift
//  BoxSDK-iOS
//
//  Created by Artur Jankowski on 08/10/2021.
//  Copyright © 2021 box. All rights reserved.
//

import Foundation

/// Represents a type of input.
public enum SignRequestSignerInputType: BoxEnum {
    /// Signature input.
    case signature
    /// Date input.
    case date
    /// Text input.
    case text
    /// Checkbox input.
    case checkbox
    /// Radio
    case radio
    /// Dropdown
    case dropdown
    /// Custom value for enum values not yet implemented in the SDK
    case customValue(String)

    public init(_ value: String) {
        switch value {
        case "signature":
            self = .signature
        case "date":
            self = .date
        case "text":
            self = .text
        case "checkbox":
            self = .checkbox
        case "radio":
            self = .radio
        case "dropdown":
            self = .dropdown
        default:
            self = .customValue(value)
        }
    }

    public var description: String {
        switch self {
        case .signature:
            return "signature"
        case .date:
            return "date"
        case .text:
            return "text"
        case .checkbox:
            return "checkbox"
        case .radio:
            return "radio"
        case .dropdown:
            return "dropdown"
        case let .customValue(value):
            return value
        }
    }
}

//    swiftlint:disable cyclomatic_complexity

/// Represents a content_type of input.
public enum SignRequestSignerInputContentType: BoxEnum {
    /// Initial
    case initial
    /// Stamp
    case stamp
    /// Signature
    case signature
    /// Company
    case company
    /// Title
    case title
    /// Email
    case email
    /// Full name
    case fullName
    /// First name
    case firstName
    /// Last name
    case lastName
    /// Text
    case text
    /// Date
    case date
    /// Checkbox
    case checkbox
    /// Attachment
    case attachment
    /// Radio
    case radio
    /// Dropdown
    case dropdown
    /// Custom value for enum values not yet implemented in the SDK
    case customValue(String)

    /// Initializer
    /// - Parameter value: The string value of the content type
    public init(_ value: String) {
        switch value {
        case "initial":
            self = .initial
        case "stamp":
            self = .stamp
        case "signature":
            self = .signature
        case "company":
            self = .company
        case "title":
            self = .title
        case "email":
            self = .email
        case "full_name":
            self = .fullName
        case "first_name":
            self = .firstName
        case "last_name":
            self = .lastName
        case "text":
            self = .text
        case "date":
            self = .date
        case "checkbox":
            self = .checkbox
        case "attachment":
            self = .attachment
        case "radio":
            self = .radio
        case "dropdown":
            self = .dropdown
        default:
            self = .customValue(value)
        }
    }

    public var description: String {
        switch self {
        case .initial:
            return "initial"
        case .stamp:
            return "stamp"
        case .signature:
            return "signature"
        case .company:
            return "company"
        case .title:
            return "title"
        case .email:
            return "email"
        case .fullName:
            return "full_name"
        case .firstName:
            return "first_name"
        case .lastName:
            return "last_name"
        case .text:
            return "text"
        case .date:
            return "date"
        case .checkbox:
            return "checkbox"
        case .attachment:
            return "attachment"
        case .radio:
            return "radio"
        case .dropdown:
            return "dropdown"
        case let .customValue(value):
            return value
        }
    }
}

//    swiftlint:enable cyclomatic_complexity

/// Prefill tags are used to prefill placeholders with signer input data. Only none value field can be included.
public class SignRequestSignerInput: BoxModel {

    // MARK: - Properties

    public private(set) var rawData: [String: Any]

    /// Type of input
    public let type: SignRequestSignerInputType?
    /// Index of page that the input is on
    public let pageIndex: Int
    /// This references the ID of a specific tag contained in a file of the sign request
    public let documentTagId: String?
    /// Text prefill value
    public let textValue: String?
    /// Checkbox prefill value
    public let checkboxValue: Bool?
    /// Date prefill value
    public let dateValue: Date?
    /// Content type value
    public let contentType: SignRequestSignerInputContentType?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        rawData = json
        type = try BoxJSONDecoder.optionalDecodeEnum(json: json, forKey: "type")
        pageIndex = try BoxJSONDecoder.decode(json: json, forKey: "page_index")
        documentTagId = try BoxJSONDecoder.optionalDecode(json: json, forKey: "document_tag_id")
        textValue = try BoxJSONDecoder.optionalDecode(json: json, forKey: "text_value")
        checkboxValue = try BoxJSONDecoder.optionalDecode(json: json, forKey: "checkbox_value")
        dateValue = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "date_value")
        contentType = try BoxJSONDecoder.optionalDecodeEnum(json: json, forKey: "content_type")
    }
}
