import Foundation

public class CreateGroupMembershipRequestBodyUserField: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
    }

    /// The ID of the user to add to the group
    public let id: String

    /// Initializer for a CreateGroupMembershipRequestBodyUserField.
    ///
    /// - Parameters:
    ///   - id: The ID of the user to add to the group
    public init(id: String) {
        self.id = id
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
    }

}
