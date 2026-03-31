import Foundation

/// A single block in a Hub Document Blocks list.
/// Text-bearing block types (`paragraph`, `section_title`, `callout_box`)
/// include a `fragment` property with rich text content.
public enum HubDocumentBlockEntryV2025R0: Codable {
    case hubParagraphTextBlockV2025R0(HubParagraphTextBlockV2025R0)
    case hubSectionTitleTextBlockV2025R0(HubSectionTitleTextBlockV2025R0)
    case hubCalloutBoxTextBlockV2025R0(HubCalloutBoxTextBlockV2025R0)
    case hubItemListBlockV2025R0(HubItemListBlockV2025R0)
    case hubDividerBlockV2025R0(HubDividerBlockV2025R0)

    private enum DiscriminatorCodingKey: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: DiscriminatorCodingKey.self) {
            if let discriminator_0 = try? container.decode(String.self, forKey: .type) {
                switch discriminator_0 {
                case "paragraph":
                    if let content = try? HubParagraphTextBlockV2025R0(from: decoder) {
                        self = .hubParagraphTextBlockV2025R0(content)
                        return
                    }

                case "section_title":
                    if let content = try? HubSectionTitleTextBlockV2025R0(from: decoder) {
                        self = .hubSectionTitleTextBlockV2025R0(content)
                        return
                    }

                case "callout_box":
                    if let content = try? HubCalloutBoxTextBlockV2025R0(from: decoder) {
                        self = .hubCalloutBoxTextBlockV2025R0(content)
                        return
                    }

                case "item_list":
                    if let content = try? HubItemListBlockV2025R0(from: decoder) {
                        self = .hubItemListBlockV2025R0(content)
                        return
                    }

                case "divider":
                    if let content = try? HubDividerBlockV2025R0(from: decoder) {
                        self = .hubDividerBlockV2025R0(content)
                        return
                    }

                default:
                    break
                }
            }

        }

        throw DecodingError.typeMismatch(HubDocumentBlockEntryV2025R0.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The type of the decoded object cannot be determined."))

    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .hubParagraphTextBlockV2025R0(let hubParagraphTextBlockV2025R0):
            try hubParagraphTextBlockV2025R0.encode(to: encoder)
        case .hubSectionTitleTextBlockV2025R0(let hubSectionTitleTextBlockV2025R0):
            try hubSectionTitleTextBlockV2025R0.encode(to: encoder)
        case .hubCalloutBoxTextBlockV2025R0(let hubCalloutBoxTextBlockV2025R0):
            try hubCalloutBoxTextBlockV2025R0.encode(to: encoder)
        case .hubItemListBlockV2025R0(let hubItemListBlockV2025R0):
            try hubItemListBlockV2025R0.encode(to: encoder)
        case .hubDividerBlockV2025R0(let hubDividerBlockV2025R0):
            try hubDividerBlockV2025R0.encode(to: encoder)
        }
    }

}
