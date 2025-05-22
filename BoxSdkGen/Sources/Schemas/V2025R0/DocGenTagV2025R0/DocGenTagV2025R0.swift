import Foundation

/// A Box Doc Gen template tag object.
public class DocGenTagV2025R0: Codable {
    private enum CodingKeys: String, CodingKey {
        case tagContent = "tag_content"
        case tagType = "tag_type"
        case jsonPaths = "json_paths"
    }

    /// The content of the tag.
    public let tagContent: String

    /// Type of the tag.
    public let tagType: DocGenTagV2025R0TagTypeField

    /// List of the paths.
    public let jsonPaths: [String]

    /// Initializer for a DocGenTagV2025R0.
    ///
    /// - Parameters:
    ///   - tagContent: The content of the tag.
    ///   - tagType: Type of the tag.
    ///   - jsonPaths: List of the paths.
    public init(tagContent: String, tagType: DocGenTagV2025R0TagTypeField, jsonPaths: [String]) {
        self.tagContent = tagContent
        self.tagType = tagType
        self.jsonPaths = jsonPaths
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        tagContent = try container.decode(String.self, forKey: .tagContent)
        tagType = try container.decode(DocGenTagV2025R0TagTypeField.self, forKey: .tagType)
        jsonPaths = try container.decode([String].self, forKey: .jsonPaths)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(tagContent, forKey: .tagContent)
        try container.encode(tagType, forKey: .tagType)
        try container.encode(jsonPaths, forKey: .jsonPaths)
    }

}
