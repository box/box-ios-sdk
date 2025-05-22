import Foundation

/// A reference to an enterprise, used when
/// nested within another resource.
public class EnterpriseReferenceV2025R0: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// The unique identifier for this enterprise
    public let id: String?

    /// `enterprise`
    public let type: EnterpriseReferenceV2025R0TypeField?

    /// Initializer for a EnterpriseReferenceV2025R0.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this enterprise
    ///   - type: `enterprise`
    public init(id: String? = nil, type: EnterpriseReferenceV2025R0TypeField? = nil) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decodeIfPresent(EnterpriseReferenceV2025R0TypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
    }

}
