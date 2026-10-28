import Foundation

/// A single page segment within a page selection item. The `type` field
/// identifies whether the segment is a single page or an inclusive page range.
public enum DocumentSplitPageSelectionSegmentV2026R0: Codable {
    case documentSplitPageSelectionSinglePageV2026R0(DocumentSplitPageSelectionSinglePageV2026R0)
    case documentSplitPageSelectionPageRangeV2026R0(DocumentSplitPageSelectionPageRangeV2026R0)

    private enum DiscriminatorCodingKey: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: DiscriminatorCodingKey.self) {
            if let discriminator_0 = try? container.decode(String.self, forKey: .type) {
                switch discriminator_0 {
                case "single_page":
                    if let content = try? DocumentSplitPageSelectionSinglePageV2026R0(from: decoder) {
                        self = .documentSplitPageSelectionSinglePageV2026R0(content)
                        return
                    }

                case "page_range":
                    if let content = try? DocumentSplitPageSelectionPageRangeV2026R0(from: decoder) {
                        self = .documentSplitPageSelectionPageRangeV2026R0(content)
                        return
                    }

                default:
                    break
                }
            }

        }

        throw DecodingError.typeMismatch(DocumentSplitPageSelectionSegmentV2026R0.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The type of the decoded object cannot be determined."))

    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .documentSplitPageSelectionSinglePageV2026R0(let documentSplitPageSelectionSinglePageV2026R0):
            try documentSplitPageSelectionSinglePageV2026R0.encode(to: encoder)
        case .documentSplitPageSelectionPageRangeV2026R0(let documentSplitPageSelectionPageRangeV2026R0):
            try documentSplitPageSelectionPageRangeV2026R0.encode(to: encoder)
        }
    }

}
