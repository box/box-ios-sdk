import Foundation

public class SkillInvocationTokenField: Codable {
    private enum CodingKeys: String, CodingKey {
        case read
        case write
    }

    /// The basics of an access token
    public let read: SkillInvocationTokenReadField?

    /// The basics of an access token
    public let write: SkillInvocationTokenWriteField?

    /// Initializer for a SkillInvocationTokenField.
    ///
    /// - Parameters:
    ///   - read: The basics of an access token
    ///   - write: The basics of an access token
    public init(read: SkillInvocationTokenReadField? = nil, write: SkillInvocationTokenWriteField? = nil) {
        self.read = read
        self.write = write
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        read = try container.decodeIfPresent(SkillInvocationTokenReadField.self, forKey: .read)
        write = try container.decodeIfPresent(SkillInvocationTokenWriteField.self, forKey: .write)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(read, forKey: .read)
        try container.encodeIfPresent(write, forKey: .write)
    }

}
