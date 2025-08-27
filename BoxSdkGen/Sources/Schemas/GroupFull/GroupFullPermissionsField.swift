import Foundation

public class GroupFullPermissionsField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case canInviteAsCollaborator = "can_invite_as_collaborator"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Specifies if the user can invite the group to collaborate on any items.
    public let canInviteAsCollaborator: Bool?

    /// Initializer for a GroupFullPermissionsField.
    ///
    /// - Parameters:
    ///   - canInviteAsCollaborator: Specifies if the user can invite the group to collaborate on any items.
    public init(canInviteAsCollaborator: Bool? = nil) {
        self.canInviteAsCollaborator = canInviteAsCollaborator
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        canInviteAsCollaborator = try container.decodeIfPresent(Bool.self, forKey: .canInviteAsCollaborator)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(canInviteAsCollaborator, forKey: .canInviteAsCollaborator)
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
