import Foundation

public class KeywordSkillCardEntriesField: Codable {
    private enum CodingKeys: String, CodingKey {
        case text
    }

    /// The text of the keyword.
    public let text: String?

    /// Initializer for a KeywordSkillCardEntriesField.
    ///
    /// - Parameters:
    ///   - text: The text of the keyword.
    public init(text: String? = nil) {
        self.text = text
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decodeIfPresent(String.self, forKey: .text)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(text, forKey: .text)
    }

}
