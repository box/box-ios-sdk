import Foundation

/// A standard representation of a group, as returned from any
/// group API endpoints by default
public class Group: GroupMini {
    private enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case modifiedAt = "modified_at"
    }

    /// When the group object was created
    public let createdAt: Date?

    /// When the group object was last modified
    public let modifiedAt: Date?

    /// Initializer for a Group.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this object
    ///   - type: `group`
    ///   - name: The name of the group
    ///   - groupType: The type of the group.
    ///   - createdAt: When the group object was created
    ///   - modifiedAt: When the group object was last modified
    public init(id: String, type: GroupBaseTypeField = GroupBaseTypeField.group, name: String? = nil, groupType: GroupMiniGroupTypeField? = nil, createdAt: Date? = nil, modifiedAt: Date? = nil) {
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt

        super.init(id: id, type: type, name: name, groupType: groupType)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
        modifiedAt = try container.decodeDateTimeIfPresent(forKey: .modifiedAt)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeDateTimeIfPresent(field: createdAt, forKey: .createdAt)
        try container.encodeDateTimeIfPresent(field: modifiedAt, forKey: .modifiedAt)
        try super.encode(to: encoder)
    }

}
