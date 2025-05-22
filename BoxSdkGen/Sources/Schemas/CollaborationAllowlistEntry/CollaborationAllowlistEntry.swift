import Foundation

/// An entry that describes an approved domain for which users can collaborate
/// with files and folders in your enterprise or vice versa.
public class CollaborationAllowlistEntry: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case domain
        case direction
        case enterprise
        case createdAt = "created_at"
    }

    /// The unique identifier for this entry
    public let id: String?

    /// `collaboration_whitelist_entry`
    public let type: CollaborationAllowlistEntryTypeField?

    /// The whitelisted domain
    public let domain: String?

    /// The direction of the collaborations to allow.
    public let direction: CollaborationAllowlistEntryDirectionField?

    public let enterprise: CollaborationAllowlistEntryEnterpriseField?

    /// The time the entry was created at
    public let createdAt: Date?

    /// Initializer for a CollaborationAllowlistEntry.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this entry
    ///   - type: `collaboration_whitelist_entry`
    ///   - domain: The whitelisted domain
    ///   - direction: The direction of the collaborations to allow.
    ///   - enterprise: 
    ///   - createdAt: The time the entry was created at
    public init(id: String? = nil, type: CollaborationAllowlistEntryTypeField? = nil, domain: String? = nil, direction: CollaborationAllowlistEntryDirectionField? = nil, enterprise: CollaborationAllowlistEntryEnterpriseField? = nil, createdAt: Date? = nil) {
        self.id = id
        self.type = type
        self.domain = domain
        self.direction = direction
        self.enterprise = enterprise
        self.createdAt = createdAt
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decodeIfPresent(CollaborationAllowlistEntryTypeField.self, forKey: .type)
        domain = try container.decodeIfPresent(String.self, forKey: .domain)
        direction = try container.decodeIfPresent(CollaborationAllowlistEntryDirectionField.self, forKey: .direction)
        enterprise = try container.decodeIfPresent(CollaborationAllowlistEntryEnterpriseField.self, forKey: .enterprise)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(domain, forKey: .domain)
        try container.encodeIfPresent(direction, forKey: .direction)
        try container.encodeIfPresent(enterprise, forKey: .enterprise)
        try container.encodeDateTimeIfPresent(field: createdAt, forKey: .createdAt)
    }

}
