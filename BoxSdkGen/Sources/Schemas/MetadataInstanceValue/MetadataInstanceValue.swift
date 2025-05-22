import Foundation

/// The value to be set or tested.
/// 
/// Required for `add`, `replace`, and `test` operations. For `add`,
/// if the value exists already the previous value will be overwritten
/// by the new value. For `replace`, the value must exist before
/// replacing.
/// 
/// For `test`, the existing value at the `path` location must match
/// the specified value.
public enum MetadataInstanceValue: Codable {
    case stringArray([String])
    case double(Double)
    case int64(Int64)
    case string(String)

    public init(from decoder: Decoder) throws {
        if let content = try? [String](from: decoder) {
            self = .stringArray(content)
            return
        }

        if let content = try? Double(from: decoder) {
            self = .double(content)
            return
        }

        if let content = try? Int64(from: decoder) {
            self = .int64(content)
            return
        }

        if let content = try? String(from: decoder) {
            self = .string(content)
            return
        }

        throw DecodingError.typeMismatch(MetadataInstanceValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The type of the decoded object cannot be determined."))

    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .stringArray(let stringArray):
            try stringArray.encode(to: encoder)
        case .double(let double):
            try double.encode(to: encoder)
        case .int64(let int64):
            try int64.encode(to: encoder)
        case .string(let string):
            try string.encode(to: encoder)
        }
    }

}
