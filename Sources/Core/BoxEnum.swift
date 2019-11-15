//
//  BoxEnum.swift
//  BoxSDK-iOS
//
//  Created by Matthew Willer on 6/11/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// General BoxEnum protocol specifying response model enum behaviour
public protocol BoxEnum: Equatable, LosslessStringConvertible, Codable, QueryParameterConvertible {
    // Box enums accept all string values for forwards-compatibility, so the initializer should not be failable

    /// Initializer
    /// - Parameter value: The string value of the enum
    init(_ value: String)
}

// MARK: Equatable

/// Extension for Equatable conformance
public extension BoxEnum {

    /// Compare equality between enum and string
    ///
    /// - Parameters:
    ///   - lhs: Enum value
    ///   - rhs: String value
    /// - Returns: Whether the enum and string are equal
    static func == (lhs: Self, rhs: String) -> Bool {
        return lhs.description == rhs
    }

    /// Compare equality between string and enum
    ///
    /// - Parameters:
    ///   - lhs: String value
    ///   - rhs: Enum value
    /// - Returns: Whether the enum and string are equal
    static func == (lhs: String, rhs: Self) -> Bool {
        return lhs == rhs.description
    }
}

// MARK: Encodable

/// Extension for Encodable conformance
public extension BoxEnum {

    /// Encode the enum to a JSON string
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
}

// MARK: QueryParameterConvertible

/// Extension for QueryParameterConvertible conformance
public extension BoxEnum {

    /// Query parameter value
    var queryParamValue: String? {
        return description
    }
}

// MARK: Decodable

/// Extension for Decodable conformance
public extension BoxEnum {

    /// Initialization using decoder
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self.init(value)
    }
}
