import Foundation

public class CollaboratorVariableVariableValueField: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// User's ID.
    public let id: String

    /// The object type.
    public let type: CollaboratorVariableVariableValueTypeField

    /// Initializer for a CollaboratorVariableVariableValueField.
    ///
    /// - Parameters:
    ///   - id: User's ID.
    ///   - type: The object type.
    public init(id: String, type: CollaboratorVariableVariableValueTypeField = CollaboratorVariableVariableValueTypeField.user) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(CollaboratorVariableVariableValueTypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
    }

}
