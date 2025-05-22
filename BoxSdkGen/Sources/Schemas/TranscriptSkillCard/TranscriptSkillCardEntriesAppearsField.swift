import Foundation

public class TranscriptSkillCardEntriesAppearsField: Codable {
    private enum CodingKeys: String, CodingKey {
        case start
    }

    /// The time in seconds when an
    /// entry should start appearing on a timeline.
    public let start: Int64?

    /// Initializer for a TranscriptSkillCardEntriesAppearsField.
    ///
    /// - Parameters:
    ///   - start: The time in seconds when an
    ///     entry should start appearing on a timeline.
    public init(start: Int64? = nil) {
        self.start = start
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        start = try container.decodeIfPresent(Int64.self, forKey: .start)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(start, forKey: .start)
    }

}
