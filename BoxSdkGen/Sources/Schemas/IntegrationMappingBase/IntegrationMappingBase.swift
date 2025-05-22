import Foundation

/// A base representation of an
/// integration mapping object.
public class IntegrationMappingBase: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// A unique identifier of a folder mapping
    /// (part of a composite key together
    /// with `integration_type`)
    public let id: String

    /// Mapping type
    public let type: IntegrationMappingBaseTypeField

    /// Initializer for a IntegrationMappingBase.
    ///
    /// - Parameters:
    ///   - id: A unique identifier of a folder mapping
    ///     (part of a composite key together
    ///     with `integration_type`)
    ///   - type: Mapping type
    public init(id: String, type: IntegrationMappingBaseTypeField = IntegrationMappingBaseTypeField.integrationMapping) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(IntegrationMappingBaseTypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
    }

}
