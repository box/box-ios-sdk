import Foundation

public class TranscriptSkillCardEntriesField: Codable {
    private enum CodingKeys: String, CodingKey {
        case text
        case appears
    }

    /// The text of the entry. This would be the transcribed text assigned
    /// to the entry on the timeline.
    public let text: String?

    /// Defines when a transcribed bit of text appears. This only includes a
    /// start time and no end time.
    public let appears: [TranscriptSkillCardEntriesAppearsField]?

    /// Initializer for a TranscriptSkillCardEntriesField.
    ///
    /// - Parameters:
    ///   - text: The text of the entry. This would be the transcribed text assigned
    ///     to the entry on the timeline.
    ///   - appears: Defines when a transcribed bit of text appears. This only includes a
    ///     start time and no end time.
    public init(text: String? = nil, appears: [TranscriptSkillCardEntriesAppearsField]? = nil) {
        self.text = text
        self.appears = appears
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decodeIfPresent(String.self, forKey: .text)
        appears = try container.decodeIfPresent([TranscriptSkillCardEntriesAppearsField].self, forKey: .appears)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(appears, forKey: .appears)
    }

}
