import Foundation

/// Mini representation of a group, including id and name of
/// group.
public class GroupMini: GroupBase {
    private enum CodingKeys: String, CodingKey {
        case name
        case groupType = "group_type"
    }

    /// The name of the group
    public let name: String?

    /// The type of the group.
    public let groupType: GroupMiniGroupTypeField?

    /// Initializer for a GroupMini.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this object
    ///   - type: `group`
    ///   - name: The name of the group
    ///   - groupType: The type of the group.
    public init(id: String, type: GroupBaseTypeField = GroupBaseTypeField.group, name: String? = nil, groupType: GroupMiniGroupTypeField? = nil) {
        self.name = name
        self.groupType = groupType

        super.init(id: id, type: type)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        groupType = try container.decodeIfPresent(GroupMiniGroupTypeField.self, forKey: .groupType)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(groupType, forKey: .groupType)
        try super.encode(to: encoder)
    }

}
