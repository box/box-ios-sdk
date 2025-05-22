import Foundation

public class CreateMetadataTemplateRequestBodyFieldsOptionsField: Codable {
    private enum CodingKeys: String, CodingKey {
        case key
    }

    /// The text value of the option. This represents both the display name of the
    /// option and the internal key used when updating templates.
    public let key: String

    /// Initializer for a CreateMetadataTemplateRequestBodyFieldsOptionsField.
    ///
    /// - Parameters:
    ///   - key: The text value of the option. This represents both the display name of the
    ///     option and the internal key used when updating templates.
    public init(key: String) {
        self.key = key
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        key = try container.decode(String.self, forKey: .key)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(key, forKey: .key)
    }

}
