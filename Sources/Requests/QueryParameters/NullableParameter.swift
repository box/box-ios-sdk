//
//  Optional.swift
//  BoxSDK-iOS
//
//  Created by Martina Stremenova on 12/07/2019.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

/// Type for updating optional parameters - parameters that can either have value of some type, or be nil.
/// Should be used mainly with optinal method parameters to differentiate between ignored parameter and parameter with a nil value.
public enum NullableParameter<T> {
    ///  Specifies value that should be set to a parameter
    case value(T)
    /// Empty value representing null
    case null
}

/// Extension for Encodable conformance
extension NullableParameter: Encodable where T: Encodable {
    /// Encode the nullable parameter to either null or its encoded value
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .null:
            try container.encodeNil()
        case let .value(value):
            try container.encode(value)
        }
    }
}
