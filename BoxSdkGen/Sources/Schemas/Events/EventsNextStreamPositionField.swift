import Foundation

public enum EventsNextStreamPositionField: Codable {
    case double(Double)
    case string(String)

    public init(from decoder: Decoder) throws {
        if let content = try? Double(from: decoder) {
            self = .double(content)
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
        case .double(let double):
            try double.encode(to: encoder)
        case .string(let string):
            try string.encode(to: encoder)
        }
    }

}
