import Foundation

public class TranscriptSkillCardEntriesField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case text
        case appears
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
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
