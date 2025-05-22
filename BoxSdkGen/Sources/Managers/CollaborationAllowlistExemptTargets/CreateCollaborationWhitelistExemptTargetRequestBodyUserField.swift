import Foundation

public class CreateCollaborationWhitelistExemptTargetRequestBodyUserField: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
    }

    /// The ID of the user to exempt.
    public let id: String

    /// Initializer for a CreateCollaborationWhitelistExemptTargetRequestBodyUserField.
    ///
    /// - Parameters:
    ///   - id: The ID of the user to exempt.
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
