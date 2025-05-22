import Foundation

public class CreateShieldInformationBarrierSegmentRestrictionRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case shieldInformationBarrierSegment = "shield_information_barrier_segment"
        case restrictedSegment = "restricted_segment"
        case type
        case shieldInformationBarrier = "shield_information_barrier"
    }

    /// The `type` and `id` of the requested
    /// shield information barrier segment.
    public let shieldInformationBarrierSegment: CreateShieldInformationBarrierSegmentRestrictionRequestBodyShieldInformationBarrierSegmentField

    /// The `type` and `id` of the restricted
    /// shield information barrier segment.
    public let restrictedSegment: CreateShieldInformationBarrierSegmentRestrictionRequestBodyRestrictedSegmentField

    /// The type of the shield barrier segment
    /// restriction for this member.
    public let type: CreateShieldInformationBarrierSegmentRestrictionRequestBodyTypeField

    public let shieldInformationBarrier: ShieldInformationBarrierBase?

    /// Initializer for a CreateShieldInformationBarrierSegmentRestrictionRequestBody.
    ///
    /// - Parameters:
    ///   - shieldInformationBarrierSegment: The `type` and `id` of the requested
    ///     shield information barrier segment.
    ///   - restrictedSegment: The `type` and `id` of the restricted
    ///     shield information barrier segment.
    ///   - type: The type of the shield barrier segment
    ///     restriction for this member.
    ///   - shieldInformationBarrier: 
    public init(shieldInformationBarrierSegment: CreateShieldInformationBarrierSegmentRestrictionRequestBodyShieldInformationBarrierSegmentField, restrictedSegment: CreateShieldInformationBarrierSegmentRestrictionRequestBodyRestrictedSegmentField, type: CreateShieldInformationBarrierSegmentRestrictionRequestBodyTypeField = CreateShieldInformationBarrierSegmentRestrictionRequestBodyTypeField.shieldInformationBarrierSegmentRestriction, shieldInformationBarrier: ShieldInformationBarrierBase? = nil) {
        self.shieldInformationBarrierSegment = shieldInformationBarrierSegment
        self.restrictedSegment = restrictedSegment
        self.type = type
        self.shieldInformationBarrier = shieldInformationBarrier
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        shieldInformationBarrierSegment = try container.decode(CreateShieldInformationBarrierSegmentRestrictionRequestBodyShieldInformationBarrierSegmentField.self, forKey: .shieldInformationBarrierSegment)
        restrictedSegment = try container.decode(CreateShieldInformationBarrierSegmentRestrictionRequestBodyRestrictedSegmentField.self, forKey: .restrictedSegment)
        type = try container.decode(CreateShieldInformationBarrierSegmentRestrictionRequestBodyTypeField.self, forKey: .type)
        shieldInformationBarrier = try container.decodeIfPresent(ShieldInformationBarrierBase.self, forKey: .shieldInformationBarrier)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(shieldInformationBarrierSegment, forKey: .shieldInformationBarrierSegment)
        try container.encode(restrictedSegment, forKey: .restrictedSegment)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(shieldInformationBarrier, forKey: .shieldInformationBarrier)
    }

}
