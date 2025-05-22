import Foundation

/// A standard representation of a
/// shield information barrier segment member object
public class ShieldInformationBarrierSegmentMember: ShieldInformationBarrierSegmentMemberMini {
    private enum CodingKeys: String, CodingKey {
        case shieldInformationBarrier = "shield_information_barrier"
        case shieldInformationBarrierSegment = "shield_information_barrier_segment"
        case createdAt = "created_at"
        case createdBy = "created_by"
        case updatedAt = "updated_at"
        case updatedBy = "updated_by"
    }

    public let shieldInformationBarrier: ShieldInformationBarrierBase?

    /// The `type` and `id` of the requested
    /// shield information barrier segment.
    public let shieldInformationBarrierSegment: ShieldInformationBarrierSegmentMemberShieldInformationBarrierSegmentField?

    /// ISO date time string when this shield
    /// information barrier object was created.
    public let createdAt: Date?

    public let createdBy: UserBase?

    /// ISO date time string when this
    /// shield information barrier segment Member was updated.
    public let updatedAt: Date?

    public let updatedBy: UserBase?

    /// Initializer for a ShieldInformationBarrierSegmentMember.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the
    ///     shield information barrier segment member
    ///   - type: The type of the shield information barrier segment member
    ///   - user: 
    ///   - shieldInformationBarrier: 
    ///   - shieldInformationBarrierSegment: The `type` and `id` of the requested
    ///     shield information barrier segment.
    ///   - createdAt: ISO date time string when this shield
    ///     information barrier object was created.
    ///   - createdBy: 
    ///   - updatedAt: ISO date time string when this
    ///     shield information barrier segment Member was updated.
    ///   - updatedBy: 
    public init(id: String? = nil, type: ShieldInformationBarrierSegmentMemberBaseTypeField? = nil, user: UserBase? = nil, shieldInformationBarrier: ShieldInformationBarrierBase? = nil, shieldInformationBarrierSegment: ShieldInformationBarrierSegmentMemberShieldInformationBarrierSegmentField? = nil, createdAt: Date? = nil, createdBy: UserBase? = nil, updatedAt: Date? = nil, updatedBy: UserBase? = nil) {
        self.shieldInformationBarrier = shieldInformationBarrier
        self.shieldInformationBarrierSegment = shieldInformationBarrierSegment
        self.createdAt = createdAt
        self.createdBy = createdBy
        self.updatedAt = updatedAt
        self.updatedBy = updatedBy

        super.init(id: id, type: type, user: user)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        shieldInformationBarrier = try container.decodeIfPresent(ShieldInformationBarrierBase.self, forKey: .shieldInformationBarrier)
        shieldInformationBarrierSegment = try container.decodeIfPresent(ShieldInformationBarrierSegmentMemberShieldInformationBarrierSegmentField.self, forKey: .shieldInformationBarrierSegment)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
        createdBy = try container.decodeIfPresent(UserBase.self, forKey: .createdBy)
        updatedAt = try container.decodeDateTimeIfPresent(forKey: .updatedAt)
        updatedBy = try container.decodeIfPresent(UserBase.self, forKey: .updatedBy)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(shieldInformationBarrier, forKey: .shieldInformationBarrier)
        try container.encodeIfPresent(shieldInformationBarrierSegment, forKey: .shieldInformationBarrierSegment)
        try container.encodeDateTimeIfPresent(field: createdAt, forKey: .createdAt)
        try container.encodeIfPresent(createdBy, forKey: .createdBy)
        try container.encodeDateTimeIfPresent(field: updatedAt, forKey: .updatedAt)
        try container.encodeIfPresent(updatedBy, forKey: .updatedBy)
        try super.encode(to: encoder)
    }

}
