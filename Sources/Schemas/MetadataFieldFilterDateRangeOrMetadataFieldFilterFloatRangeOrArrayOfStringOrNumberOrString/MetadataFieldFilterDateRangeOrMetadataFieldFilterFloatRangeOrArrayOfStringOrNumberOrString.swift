import Foundation

public enum MetadataFieldFilterDateRangeOrMetadataFieldFilterFloatRangeOrArrayOfStringOrNumberOrString: Codable {
    case stringArray([String])
    case double(Double)
    case metadataFieldFilterDateRange(MetadataFieldFilterDateRange)
    case metadataFieldFilterFloatRange(MetadataFieldFilterFloatRange)
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

        if let content = try? MetadataFieldFilterDateRange(from: decoder) {
            self = .metadataFieldFilterDateRange(content)
            return
        }

        if let content = try? MetadataFieldFilterFloatRange(from: decoder) {
            self = .metadataFieldFilterFloatRange(content)
            return
        }

        if let content = try? String(from: decoder) {
            self = .string(content)
            return
        }

        throw DecodingError.typeMismatch(MetadataFieldFilterDateRangeOrMetadataFieldFilterFloatRangeOrArrayOfStringOrNumberOrString.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The type of the decoded object cannot be determined."))

    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .stringArray(let stringArray):
            try stringArray.encode(to: encoder)
        case .double(let double):
            try double.encode(to: encoder)
        case .metadataFieldFilterDateRange(let metadataFieldFilterDateRange):
            try metadataFieldFilterDateRange.encode(to: encoder)
        case .metadataFieldFilterFloatRange(let metadataFieldFilterFloatRange):
            try metadataFieldFilterFloatRange.encode(to: encoder)
        case .string(let string):
            try string.encode(to: encoder)
        }
    }

}
