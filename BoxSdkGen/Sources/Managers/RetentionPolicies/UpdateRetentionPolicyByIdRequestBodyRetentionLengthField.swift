import Foundation

public enum UpdateRetentionPolicyByIdRequestBodyRetentionLengthField: Codable {
    case int(Int)
    case string(String)

    public init(from decoder: Decoder) throws {
        if let content = try? Int(from: decoder) {
            self = .int(content)
            return
        }

        if let content = try? String(from: decoder) {
            self = .string(content)
            return
        }

        throw DecodingError.typeMismatch(UpdateRetentionPolicyByIdRequestBodyRetentionLengthField.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The type of the decoded object cannot be determined."))

    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .int(let int):
            try int.encode(to: encoder)
        case .string(let string):
            try string.encode(to: encoder)
        }
    }

}
