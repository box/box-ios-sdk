import Foundation

/// Validation rules for the supported Document Split create request types.
public enum DocumentSplitCreateRequestTypeV2026R0: Codable {
    case documentSplitCreateRequestManualV2026R0(DocumentSplitCreateRequestManualV2026R0)
    case documentSplitCreateRequestPageSelectionV2026R0(DocumentSplitCreateRequestPageSelectionV2026R0)
    case documentSplitCreateRequestSmartV2026R0(DocumentSplitCreateRequestSmartV2026R0)

    public init(from decoder: Decoder) throws {
        if let content = try? DocumentSplitCreateRequestManualV2026R0(from: decoder) {
            self = .documentSplitCreateRequestManualV2026R0(content)
            return
        }

        if let content = try? DocumentSplitCreateRequestPageSelectionV2026R0(from: decoder) {
            self = .documentSplitCreateRequestPageSelectionV2026R0(content)
            return
        }

        if let content = try? DocumentSplitCreateRequestSmartV2026R0(from: decoder) {
            self = .documentSplitCreateRequestSmartV2026R0(content)
            return
        }

        throw DecodingError.typeMismatch(DocumentSplitCreateRequestTypeV2026R0.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The type of the decoded object cannot be determined."))

    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .documentSplitCreateRequestManualV2026R0(let documentSplitCreateRequestManualV2026R0):
            try documentSplitCreateRequestManualV2026R0.encode(to: encoder)
        case .documentSplitCreateRequestPageSelectionV2026R0(let documentSplitCreateRequestPageSelectionV2026R0):
            try documentSplitCreateRequestPageSelectionV2026R0.encode(to: encoder)
        case .documentSplitCreateRequestSmartV2026R0(let documentSplitCreateRequestSmartV2026R0):
            try documentSplitCreateRequestSmartV2026R0.encode(to: encoder)
        }
    }

}
