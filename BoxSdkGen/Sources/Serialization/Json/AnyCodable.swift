import Foundation

/// A flexible representation of any value that can be encoded or decoded via `Codable`.
///
/// This enum supports primitive types (Int, Double, String, Bool),
/// arrays and dictionaries of `AnyCodable`, and custom `Codable` types.
///
public enum AnyCodable: Codable {
    case int(Int)
    case double(Double)
    case bool(Bool)
    case string(String)
    case array([AnyCodable])
    case dictionary([String: AnyCodable])
    case codable(Codable)

    /// Creates an `AnyCodable` instance from any `Codable` value.
    ///
    /// - Parameter value: The value to wrap.a
    public init<T: Codable>(_ value: T) {
        switch value {
        case let v as Int: self = .int(v)
        case let v as Double: self = .double(v)
        case let v as Bool: self = .bool(v)
        case let v as String: self = .string(v)
        case let v as [AnyCodable]: self = .array(v)
        case let v as [String: AnyCodable]: self = .dictionary(v)
        default: self = .codable(value)
        }
    }

    /// Retrieves the raw value stored inside the `AnyCodable`.
    ///
    public var value: Any {
         switch self {
         case .int(let v): return v
         case .double(let v): return v
         case .bool(let v): return v
         case .string(let v): return v
         case .array(let arr): return arr.map { $0.value }
         case .dictionary(let dict):
             return dict.mapValues { $0.value }
         case .codable(let codable):
             return codable
         }
     }

    /// Encodes the wrapped value to the given encoder.
    ///
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .int(let v): try container.encode(v)
        case .double(let v): try container.encode(v)
        case .bool(let v): try container.encode(v)
        case .string(let v): try container.encode(v)
        case .array(let v): try container.encode(v)
        case .dictionary(let v): try container.encode(v)
        case .codable(let box): try box.encode(to: encoder)
        }
    }

    /// Decodes the wrapped value from the given decoder.
    ///
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(Int.self) {
            self = .int(value)
        } else if let value = try? container.decode(Double.self) {
            self = .double(value)
        } else if let value = try? container.decode(Bool.self) {
            self = .bool(value)
        } else if let value = try? container.decode(String.self) {
            self = .string(value)
        } else if let value = try? container.decode([AnyCodable].self) {
            self = .array(value)
        } else if let value = try? container.decode([String: AnyCodable].self) {
            self = .dictionary(value)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown type")
        }
    }
}

public extension AnyCodable {
    /// Returns the associated `Int` value if this instance is `.int`, otherwise `nil`.
    ///
    var intValue: Int? {
        if case .int(let v) = self { return v }
        return nil
    }

    /// Returns the associated `Double` value if this instance is `.double`, otherwise `nil`.
    ///
    var doubleValue: Double? {
        if case .double(let v) = self { return v }
        return nil
    }

    /// Returns the associated `Bool` value if this instance is `.bool`, otherwise `nil`.
    ///
    var boolValue: Bool? {
        if case .bool(let v) = self { return v }
        return nil
    }

    /// Returns the associated `String` value if this instance is `.string`, otherwise `nil`.
    ///
    var stringValue: String? {
        if case .string(let v) = self { return v }
        return nil
    }

    /// Returns the associated array of `AnyCodable` if this instance is `.array`, otherwise `nil`.
    ///
    var arrayValue: [AnyCodable]? {
        if case .array(let v) = self { return v }
        return nil
    }

    /// Returns the associated dictionary of `[String: AnyCodable]` if this instance is `.dictionary`, otherwise `nil`.
    ///
    var dictionaryValue: [String: AnyCodable]? {
        if case .dictionary(let v) = self { return v }
        return nil
    }

    /// Returns the associated `CodableBox` if this instance is `.codable`, otherwise `nil`.
    ///
    var codableValue: Codable? {
        if case .codable(let v) = self { return v }
        return nil
    }
}

// MARK: - Literal Conformances

extension AnyCodable: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = .int(value)
    }
}

extension AnyCodable: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = .double(value)
    }
}

extension AnyCodable: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        self = .bool(value)
    }
}

extension AnyCodable: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .string(value)
    }
}

extension AnyCodable: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: AnyCodable...) {
        self = .array(elements)
    }
}

extension AnyCodable: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, AnyCodable)...) {
        var dict = [String: AnyCodable]()
        for (k, v) in elements {
            dict[k] = v
        }
        self = .dictionary(dict)
    }
}

// MARK: - ParameterConvertible Conformance

extension AnyCodable: ParameterConvertible {
    public var paramValue: String? {
        switch self {
        case .int(let v): return v.paramValue
        case .double(let v): return v.paramValue
        case .bool(let v): return v.paramValue
        case .string(let v): return v.paramValue
        case .array(let arr): return arr.paramValue
        case .dictionary(let dict):
            let content = dict.map { "\($0): \($1.paramValue ?? "")" }.joined(separator: ", ")
               return "{" + content + "}"
        case .codable(let codable):
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            if let data = try? encoder.encode(AnyCodable.codable(codable)),
               let jsonString = String(data: data, encoding: .utf8) {
                return jsonString
            } else {
                return nil
            }
        }
    }
}

// MARK: - CustomStringConvertible Conformance

extension AnyCodable: CustomStringConvertible {
    public var description: String {
        switch self {
        case .int(let v): return "Int(\(v))"
        case .double(let v): return "Double(\(v))"
        case .bool(let v): return "Bool(\(v))"
        case .string(let v): return "String(\"\(v)\")"
        case .array(let arr): return "Array(\(arr.map { $0.description }.joined(separator: ", ")))"
        case .dictionary(let dict):
            let dictDescription = dict.map { "\"\($0)\": \($1.description)" }
                .joined(separator: ", ")
            return "Dictionary({\(dictDescription)})"
        case .codable(let codable):
            return "Codable(\(codable))"
        }
    }
}
