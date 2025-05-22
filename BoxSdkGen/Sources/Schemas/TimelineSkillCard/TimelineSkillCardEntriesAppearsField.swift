import Foundation

public class TimelineSkillCardEntriesAppearsField: Codable {
    private enum CodingKeys: String, CodingKey {
        case start
        case end
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

}
