import Foundation

/// Represents a tri-state value used for encoding/decoding:
/// - `.value(T)`: contains a real value
/// - `.null`: explicitly set to `null` (e.g. for clearing values in APIs)
/// - `.unset`: not set at all (field will be omitted when encoded)
public enum TriStateField<T: Codable>: Codable {
    case value(T)
    case null
    case unset

    /// Extracts the raw value if it exists.
    /// Returns `nil` for both `.null` and `.unset`.
    var rawValue: T? {
        switch self {
        case .value(let v): return v
        default: return nil
        }
    }

    /// Initializes the enum based on an optional wrapped value.
    /// - If value is non-nil, assigns `.value(value)`.
    /// - If value is nil, assigns `.unset` (not encoded).
    init(wrappedValue: T?) {
        if let value = wrappedValue {
            self = .value(value)
        } else {
            self = .unset
        }
    }

    /// Decodes the enum from a single value container.
    /// - If the value is null, assigns `.null`.
    /// - Otherwise, decodes and assigns `.value(T)`.
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self = .null
        } else {
            let value = try container.decode(T.self)
            self = .value(value)
        }
    }

    /// Encodes the enum to a single value container.
    /// - `.value(T)` is encoded normally.
    /// - `.null` is encoded as `null`.
    /// - `.unset` is not encoded at all.
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .value(let value):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case .null:
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        case .unset:
            break
        }
    }
}

// MARK: - Convenience Initializers

extension TriStateField {
    /// Convenience initializer to explicitly wrap a value.
    public init(_ value: T) {
        self = .value(value)
    }
}

// MARK: - Literal Conformances

/// Allows `TriStateField` to be initialized with `nil`, resulting in `.unset`
extension TriStateField: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self = .unset
    }
}

/// Allows `TriStateField<String>` to be initialized with string literals
extension TriStateField: ExpressibleByStringLiteral where T == String {
    public init(stringLiteral value: StringLiteralType) {
        self = .value(value)
    }
}

/// Enables extended grapheme cluster literal (e.g., emojis, complex characters)
extension TriStateField: ExpressibleByExtendedGraphemeClusterLiteral where T == String {
    public init(extendedGraphemeClusterLiteral value: String) {
        self = .value(value)
    }
}

/// Enables unicode scalar literal initialization
extension TriStateField: ExpressibleByUnicodeScalarLiteral where T == String {
    public init(unicodeScalarLiteral value: String) {
        self = .value(value)
    }
}

/// Enables integer literal initialization for `TriStateField<Int>`
extension TriStateField: ExpressibleByIntegerLiteral where T == Int {
    public init(integerLiteral value: IntegerLiteralType) {
        self = .value(value)
    }
}

/// Enables boolean literal initialization for `TriStateField<Bool>`
extension TriStateField: ExpressibleByBooleanLiteral where T == Bool {
    public init(booleanLiteral value: BooleanLiteralType) {
        self = .value(value)
    }
}
