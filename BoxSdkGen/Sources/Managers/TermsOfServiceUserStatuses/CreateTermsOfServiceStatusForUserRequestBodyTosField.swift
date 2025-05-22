import Foundation

public class CreateTermsOfServiceStatusForUserRequestBodyTosField: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// The ID of terms of service
    public let id: String

    /// The type of object.
    public let type: CreateTermsOfServiceStatusForUserRequestBodyTosTypeField

    /// Initializer for a CreateTermsOfServiceStatusForUserRequestBodyTosField.
    ///
    /// - Parameters:
    ///   - id: The ID of terms of service
    ///   - type: The type of object.
    public init(id: String, type: CreateTermsOfServiceStatusForUserRequestBodyTosTypeField = CreateTermsOfServiceStatusForUserRequestBodyTosTypeField.termsOfService) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(CreateTermsOfServiceStatusForUserRequestBodyTosTypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
    }

}
