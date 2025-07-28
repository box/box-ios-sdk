import Foundation

public class CreateGroupMembershipRequestBody: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case user
        case group
        case role
        case configurablePermissions = "configurable_permissions"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The user to add to the group.
    public let user: CreateGroupMembershipRequestBodyUserField

    /// The group to add the user to.
    public let group: CreateGroupMembershipRequestBodyGroupField

    /// The role of the user in the group.
    public let role: CreateGroupMembershipRequestBodyRoleField?

    /// Custom configuration for the permissions an admin
    /// if a group will receive. This option has no effect
    /// on members with a role of `member`.
    /// 
    /// Setting these permissions overwrites the default
    /// access levels of an admin.
    /// 
    /// Specifying a value of `null` for this object will disable
    /// all configurable permissions. Specifying permissions will set
    /// them accordingly, omitted permissions will be enabled by default.
    @CodableTriState public private(set) var configurablePermissions: [String: Bool]?

    /// Initializer for a CreateGroupMembershipRequestBody.
    ///
    /// - Parameters:
    ///   - user: The user to add to the group.
    ///   - group: The group to add the user to.
    ///   - role: The role of the user in the group.
    ///   - configurablePermissions: Custom configuration for the permissions an admin
    ///     if a group will receive. This option has no effect
    ///     on members with a role of `member`.
    ///     
    ///     Setting these permissions overwrites the default
    ///     access levels of an admin.
    ///     
    ///     Specifying a value of `null` for this object will disable
    ///     all configurable permissions. Specifying permissions will set
    ///     them accordingly, omitted permissions will be enabled by default.
    public init(user: CreateGroupMembershipRequestBodyUserField, group: CreateGroupMembershipRequestBodyGroupField, role: CreateGroupMembershipRequestBodyRoleField? = nil, configurablePermissions: TriStateField<[String: Bool]> = nil) {
        self.user = user
        self.group = group
        self.role = role
        self._configurablePermissions = CodableTriState(state: configurablePermissions)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        user = try container.decode(CreateGroupMembershipRequestBodyUserField.self, forKey: .user)
        group = try container.decode(CreateGroupMembershipRequestBodyGroupField.self, forKey: .group)
        role = try container.decodeIfPresent(CreateGroupMembershipRequestBodyRoleField.self, forKey: .role)
        configurablePermissions = try container.decodeIfPresent([String: Bool].self, forKey: .configurablePermissions)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(user, forKey: .user)
        try container.encode(group, forKey: .group)
        try container.encodeIfPresent(role, forKey: .role)
        try container.encode(field: _configurablePermissions.state, forKey: .configurablePermissions)
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
