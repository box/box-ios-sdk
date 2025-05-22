import Foundation

public class CreateTermsOfServiceStatusForUserRequestBodyUserField: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// The ID of user
    public let id: String

    /// The type of object.
    public let type: CreateTermsOfServiceStatusForUserRequestBodyUserTypeField

    /// Initializer for a CreateTermsOfServiceStatusForUserRequestBodyUserField.
    ///
    /// - Parameters:
    ///   - id: The ID of user
    ///   - type: The type of object.
    public init(id: String, type: CreateTermsOfServiceStatusForUserRequestBodyUserTypeField = CreateTermsOfServiceStatusForUserRequestBodyUserTypeField.user) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(CreateTermsOfServiceStatusForUserRequestBodyUserTypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
    }

}
