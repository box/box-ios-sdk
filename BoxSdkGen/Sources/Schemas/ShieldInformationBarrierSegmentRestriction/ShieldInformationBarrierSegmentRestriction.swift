import Foundation

/// A standard representation of a
/// segment restriction of a shield information barrier
/// object
public class ShieldInformationBarrierSegmentRestriction: ShieldInformationBarrierSegmentRestrictionMini {
    private enum CodingKeys: String, CodingKey {
        case shieldInformationBarrier = "shield_information_barrier"
        case createdAt = "created_at"
        case createdBy = "created_by"
        case updatedAt = "updated_at"
        case updatedBy = "updated_by"
    }

    public let shieldInformationBarrier: ShieldInformationBarrierBase?

    /// ISO date time string when this
    /// shield information barrier
    /// Segment Restriction object was created.
    public let createdAt: Date?

    public let createdBy: UserBase?

    /// ISO date time string when this
    /// shield information barrier segment
    /// Restriction was updated.
    public let updatedAt: Date?

    public let updatedBy: UserBase?

    /// Initializer for a ShieldInformationBarrierSegmentRestriction.
    ///
    /// - Parameters:
    ///   - shieldInformationBarrierSegment: The `type` and `id` of the
    ///     requested shield information barrier segment.
    ///   - restrictedSegment: The `type` and `id` of the
    ///     restricted shield information barrier segment.
    ///   - type: Shield information barrier segment restriction
    ///   - id: The unique identifier for the
    ///     shield information barrier segment restriction.
    ///   - shieldInformationBarrier: 
    ///   - createdAt: ISO date time string when this
    ///     shield information barrier
    ///     Segment Restriction object was created.
    ///   - createdBy: 
    ///   - updatedAt: ISO date time string when this
    ///     shield information barrier segment
    ///     Restriction was updated.
    ///   - updatedBy: 
    public init(shieldInformationBarrierSegment: ShieldInformationBarrierSegmentRestrictionMiniShieldInformationBarrierSegmentField, restrictedSegment: ShieldInformationBarrierSegmentRestrictionMiniRestrictedSegmentField, type: ShieldInformationBarrierSegmentRestrictionBaseTypeField? = nil, id: String? = nil, shieldInformationBarrier: ShieldInformationBarrierBase? = nil, createdAt: Date? = nil, createdBy: UserBase? = nil, updatedAt: Date? = nil, updatedBy: UserBase? = nil) {
        self.shieldInformationBarrier = shieldInformationBarrier
        self.createdAt = createdAt
        self.createdBy = createdBy
        self.updatedAt = updatedAt
        self.updatedBy = updatedBy

        super.init(shieldInformationBarrierSegment: shieldInformationBarrierSegment, restrictedSegment: restrictedSegment, type: type, id: id)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        shieldInformationBarrier = try container.decodeIfPresent(ShieldInformationBarrierBase.self, forKey: .shieldInformationBarrier)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
        createdBy = try container.decodeIfPresent(UserBase.self, forKey: .createdBy)
        updatedAt = try container.decodeDateTimeIfPresent(forKey: .updatedAt)
        updatedBy = try container.decodeIfPresent(UserBase.self, forKey: .updatedBy)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(shieldInformationBarrier, forKey: .shieldInformationBarrier)
        try container.encodeDateTimeIfPresent(field: createdAt, forKey: .createdAt)
        try container.encodeIfPresent(createdBy, forKey: .createdBy)
        try container.encodeDateTimeIfPresent(field: updatedAt, forKey: .updatedAt)
        try container.encodeIfPresent(updatedBy, forKey: .updatedBy)
        try super.encode(to: encoder)
    }

}
