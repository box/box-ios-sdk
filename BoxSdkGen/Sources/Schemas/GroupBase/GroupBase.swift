import Foundation

/// A base representation of a group.
public class GroupBase: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// The unique identifier for this object
    public let id: String

    /// `group`
    public let type: GroupBaseTypeField

    /// Initializer for a GroupBase.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this object
    ///   - type: `group`
    public init(id: String, type: GroupBaseTypeField = GroupBaseTypeField.group) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(GroupBaseTypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
    }

}
