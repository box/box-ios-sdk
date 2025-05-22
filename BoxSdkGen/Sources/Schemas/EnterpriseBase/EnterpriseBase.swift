import Foundation

/// A mini representation of a enterprise, used when
/// nested within another resource.
public class EnterpriseBase: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// The unique identifier for this enterprise
    public let id: String?

    /// `enterprise`
    public let type: EnterpriseBaseTypeField?

    /// Initializer for a EnterpriseBase.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this enterprise
    ///   - type: `enterprise`
    public init(id: String? = nil, type: EnterpriseBaseTypeField? = nil) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decodeIfPresent(EnterpriseBaseTypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
    }

}
