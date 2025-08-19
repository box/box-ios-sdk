import Foundation

/// Defines items convertible to query/header parameter
public protocol ParameterConvertible {
    /// Query parameter value
    var paramValue: String? { get }
}

extension String: ParameterConvertible {
    /// Query parameter value
    public var paramValue: String? {
        return self
    }
}

extension Int: ParameterConvertible {
    /// Query parameter value
    public var paramValue: String? {
        return String(self)
    }
}

extension Double: ParameterConvertible {
    /// Query parameter value
    public var paramValue: String? {
        return String(self)
    }
}

extension Bool: ParameterConvertible {
    /// Query parameter value
    public var paramValue: String? {
        return self ? "true" : "false"
    }
}

extension NSNumber: ParameterConvertible {
    /// Query parameter value
    public var paramValue: String? {
        return stringValue
    }
}

extension NSString: ParameterConvertible {
    /// Query parameter value
    public var paramValue: String? {
        return String(self)
    }
}

extension Array: ParameterConvertible where Element: Encodable {
    /// Query parameter value
    public var paramValue: String? {
        if Element.self is AnyClass {
            return try? self.serializeToString()
        } else if let array = self as? [ParameterConvertible] {
            return array.compactMap { $0.paramValue }.joined(separator: ",")
        }

        return nil
    }
}

extension Optional: ParameterConvertible where Wrapped: ParameterConvertible {
    /// Query parameter value
    public var paramValue: String? {
        if case let .some(something) = self {
            return something.paramValue
        }
        else {
            return nil
        }
    }
}
