import Foundation

public class GroupFullPermissionsField: Codable {
    private enum CodingKeys: String, CodingKey {
        case canInviteAsCollaborator = "can_invite_as_collaborator"
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

}
