import Foundation

public class UpdateAllSkillCardsOnFileRequestBodyMetadataField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case cards
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// A list of Box Skill cards to apply to this file.
    public let cards: [KeywordSkillCardOrStatusSkillCardOrTimelineSkillCardOrTranscriptSkillCard]?

    /// Initializer for a UpdateAllSkillCardsOnFileRequestBodyMetadataField.
    ///
    /// - Parameters:
    ///   - cards: A list of Box Skill cards to apply to this file.
    public init(cards: [KeywordSkillCardOrStatusSkillCardOrTimelineSkillCardOrTranscriptSkillCard]? = nil) {
        self.cards = cards
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cards = try container.decodeIfPresent([KeywordSkillCardOrStatusSkillCardOrTimelineSkillCardOrTranscriptSkillCard].self, forKey: .cards)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(cards, forKey: .cards)
    }

    /// Sets the raw JSON data.
    ///
    /// - Parameters:
    ///   - rawData: A dictionary containing the raw JSON data
    func setRawData(rawData: [String: Any]?) {
        self._rawData = rawData
    }

    /// Gets the raw JSON data
    /// - Returns: The `[String: Any]?`.
    func getRawData() -> [String: Any]? {
        return self._rawData
    }

}
