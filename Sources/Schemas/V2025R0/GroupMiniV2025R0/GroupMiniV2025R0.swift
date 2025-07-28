import Foundation

/// Mini representation of a group, including id and name of
/// group.
public class GroupMiniV2025R0: GroupBaseV2025R0 {
    private enum CodingKeys: String, CodingKey {
        case name
        case groupType = "group_type"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public override var rawData: [String: Any]? {
        return _rawData
    }


    /// The name of the group.
    public let name: String?

    /// The type of the group.
    public let groupType: GroupMiniV2025R0GroupTypeField?

    /// Initializer for a GroupMiniV2025R0.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this object.
    ///   - type: The value will always be `group`.
    ///   - name: The name of the group.
    ///   - groupType: The type of the group.
    public init(id: String, type: GroupBaseV2025R0TypeField = GroupBaseV2025R0TypeField.group, name: String? = nil, groupType: GroupMiniV2025R0GroupTypeField? = nil) {
        self.name = name
        self.groupType = groupType

        super.init(id: id, type: type)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        groupType = try container.decodeIfPresent(GroupMiniV2025R0GroupTypeField.self, forKey: .groupType)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(groupType, forKey: .groupType)
        try super.encode(to: encoder)
    }

    /// Sets the raw JSON data.
    ///
    /// - Parameters:
    ///   - rawData: A dictionary containing the raw JSON data
    override func setRawData(rawData: [String: Any]?) {
        self._rawData = rawData
    }

    /// Gets the raw JSON data
    /// - Returns: The `[String: Any]?`.
    override func getRawData() -> [String: Any]? {
        return self._rawData
    }

}
