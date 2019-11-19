//
//  QueryParameterConvertible.swift
//  BoxSDK
//
//  Created by Daniel Cech on 16/04/2019.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// Defines items convertible to query parameter
public protocol QueryParameterConvertible {
    /// Query parameter value
    var queryParamValue: String? { get }
}

extension String: QueryParameterConvertible {
    /// Query parameter value
    public var queryParamValue: String? {
        return self
    }
}

extension Int: QueryParameterConvertible {
    /// Query parameter value
    public var queryParamValue: String? {
        return String(self)
    }
}

extension Bool: QueryParameterConvertible {
    /// Query parameter value
    public var queryParamValue: String? {
        return self ? "true" : "false"
    }
}

extension NSNumber: QueryParameterConvertible {
    /// Query parameter value
    public var queryParamValue: String? {
        return stringValue
    }
}

extension NSString: QueryParameterConvertible {
    /// Query parameter value
    public var queryParamValue: String? {
        return String(self)
    }
}

extension Array: QueryParameterConvertible where Element: StringProtocol {
    /// Query parameter value
    public var queryParamValue: String? {
        return joined(separator: ",")
    }
}

extension Optional: QueryParameterConvertible where Wrapped: QueryParameterConvertible {
    /// Query parameter value
    public var queryParamValue: String? {
        if case let .some(something) = self {
            return something.queryParamValue
        }
        else {
            return nil
        }
    }
}
