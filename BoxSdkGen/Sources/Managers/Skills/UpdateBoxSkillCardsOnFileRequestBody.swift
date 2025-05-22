import Foundation

public class UpdateBoxSkillCardsOnFileRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case op
        case path
        case value
    }

    /// `replace`
    public let op: UpdateBoxSkillCardsOnFileRequestBodyOpField?

    /// The JSON Path that represents the card to replace. In most cases
    /// this will be in the format `/cards/{index}` where `index` is the
    /// zero-indexed position of the card in the list of cards.
    public let path: String?

    public let value: KeywordSkillCardOrStatusSkillCardOrTimelineSkillCardOrTranscriptSkillCard?

    /// Initializer for a UpdateBoxSkillCardsOnFileRequestBody.
    ///
    /// - Parameters:
    ///   - op: `replace`
    ///   - path: The JSON Path that represents the card to replace. In most cases
    ///     this will be in the format `/cards/{index}` where `index` is the
    ///     zero-indexed position of the card in the list of cards.
    ///   - value: 
    public init(op: UpdateBoxSkillCardsOnFileRequestBodyOpField? = nil, path: String? = nil, value: KeywordSkillCardOrStatusSkillCardOrTimelineSkillCardOrTranscriptSkillCard? = nil) {
        self.op = op
        self.path = path
        self.value = value
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        op = try container.decodeIfPresent(UpdateBoxSkillCardsOnFileRequestBodyOpField.self, forKey: .op)
        path = try container.decodeIfPresent(String.self, forKey: .path)
        value = try container.decodeIfPresent(KeywordSkillCardOrStatusSkillCardOrTimelineSkillCardOrTranscriptSkillCard.self, forKey: .value)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(op, forKey: .op)
        try container.encodeIfPresent(path, forKey: .path)
        try container.encodeIfPresent(value, forKey: .value)
    }

}
