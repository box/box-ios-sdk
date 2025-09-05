import Foundation

public class TimelineSkillCardEntriesAppearsField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case start
        case end
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The time in seconds when an
    /// entry should start appearing on a timeline.
    public let start: Int64?

    /// The time in seconds when an
    /// entry should stop appearing on a timeline.
    public let end: Int64?

    /// Initializer for a TimelineSkillCardEntriesAppearsField.
    ///
    /// - Parameters:
    ///   - start: The time in seconds when an
    ///     entry should start appearing on a timeline.
    ///   - end: The time in seconds when an
    ///     entry should stop appearing on a timeline.
    public init(start: Int64? = nil, end: Int64? = nil) {
        self.start = start
        self.end = end
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        start = try container.decodeIfPresent(Int64.self, forKey: .start)
        end = try container.decodeIfPresent(Int64.self, forKey: .end)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(start, forKey: .start)
        try container.encodeIfPresent(end, forKey: .end)
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
