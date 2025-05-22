import Foundation

/// A standard representation of a
/// shield information barrier object
public class ShieldInformationBarrier: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case enterprise
        case status
        case createdAt = "created_at"
        case createdBy = "created_by"
        case updatedAt = "updated_at"
        case updatedBy = "updated_by"
        case enabledAt = "enabled_at"
        case enabledBy = "enabled_by"
    }

    /// The unique identifier for the shield information barrier
    public let id: String?

    /// The type of the shield information barrier
    public let type: ShieldInformationBarrierTypeField?

    /// The `type` and `id` of enterprise this barrier is under.
    public let enterprise: EnterpriseBase?

    /// Status of the shield information barrier
    public let status: ShieldInformationBarrierStatusField?

    /// ISO date time string when this
    /// shield information barrier object was created.
    public let createdAt: Date?

    /// The user who created this shield information barrier.
    public let createdBy: UserBase?

    /// ISO date time string when this shield information barrier was updated.
    public let updatedAt: Date?

    /// The user that updated this shield information barrier.
    public let updatedBy: UserBase?

    /// ISO date time string when this shield information barrier was enabled.
    public let enabledAt: Date?

    public let enabledBy: UserBase?

    /// Initializer for a ShieldInformationBarrier.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the shield information barrier
    ///   - type: The type of the shield information barrier
    ///   - enterprise: The `type` and `id` of enterprise this barrier is under.
    ///   - status: Status of the shield information barrier
    ///   - createdAt: ISO date time string when this
    ///     shield information barrier object was created.
    ///   - createdBy: The user who created this shield information barrier.
    ///   - updatedAt: ISO date time string when this shield information barrier was updated.
    ///   - updatedBy: The user that updated this shield information barrier.
    ///   - enabledAt: ISO date time string when this shield information barrier was enabled.
    ///   - enabledBy: 
    public init(id: String? = nil, type: ShieldInformationBarrierTypeField? = nil, enterprise: EnterpriseBase? = nil, status: ShieldInformationBarrierStatusField? = nil, createdAt: Date? = nil, createdBy: UserBase? = nil, updatedAt: Date? = nil, updatedBy: UserBase? = nil, enabledAt: Date? = nil, enabledBy: UserBase? = nil) {
        self.id = id
        self.type = type
        self.enterprise = enterprise
        self.status = status
        self.createdAt = createdAt
        self.createdBy = createdBy
        self.updatedAt = updatedAt
        self.updatedBy = updatedBy
        self.enabledAt = enabledAt
        self.enabledBy = enabledBy
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decodeIfPresent(ShieldInformationBarrierTypeField.self, forKey: .type)
        enterprise = try container.decodeIfPresent(EnterpriseBase.self, forKey: .enterprise)
        status = try container.decodeIfPresent(ShieldInformationBarrierStatusField.self, forKey: .status)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
        createdBy = try container.decodeIfPresent(UserBase.self, forKey: .createdBy)
        updatedAt = try container.decodeDateTimeIfPresent(forKey: .updatedAt)
        updatedBy = try container.decodeIfPresent(UserBase.self, forKey: .updatedBy)
        enabledAt = try container.decodeDateTimeIfPresent(forKey: .enabledAt)
        enabledBy = try container.decodeIfPresent(UserBase.self, forKey: .enabledBy)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(enterprise, forKey: .enterprise)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeDateTimeIfPresent(field: createdAt, forKey: .createdAt)
        try container.encodeIfPresent(createdBy, forKey: .createdBy)
        try container.encodeDateTimeIfPresent(field: updatedAt, forKey: .updatedAt)
        try container.encodeIfPresent(updatedBy, forKey: .updatedBy)
        try container.encodeDateTimeIfPresent(field: enabledAt, forKey: .enabledAt)
        try container.encodeIfPresent(enabledBy, forKey: .enabledBy)
    }

}
