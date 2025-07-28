import Foundation

public enum EventsNextStreamPositionField: Codable {
    case int64(Int64)
    case string(String)

    public init(from decoder: Decoder) throws {
        if let content = try? Int64(from: decoder) {
            self = .int64(content)
            return
        }

        if let content = try? String(from: decoder) {
            self = .string(content)
            return
        }

        throw DecodingError.typeMismatch(EventsNextStreamPositionField.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The type of the decoded object cannot be determined."))

    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .int64(let int64):
            try int64.encode(to: encoder)
        case .string(let string):
            try string.encode(to: encoder)
        }
    }

}
