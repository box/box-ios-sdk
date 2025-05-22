import Foundation

public class UserFullEnterpriseField: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case name
    }

    /// The unique identifier for this enterprise.
    public let id: String?

    /// `enterprise`
    public let type: UserFullEnterpriseTypeField?

    /// The name of the enterprise
    public let name: String?

    /// Initializer for a UserFullEnterpriseField.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this enterprise.
    ///   - type: `enterprise`
    ///   - name: The name of the enterprise
    public init(id: String? = nil, type: UserFullEnterpriseTypeField? = nil, name: String? = nil) {
        self.id = id
        self.type = type
        self.name = name
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decodeIfPresent(UserFullEnterpriseTypeField.self, forKey: .type)
        name = try container.decodeIfPresent(String.self, forKey: .name)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(name, forKey: .name)
    }

}
