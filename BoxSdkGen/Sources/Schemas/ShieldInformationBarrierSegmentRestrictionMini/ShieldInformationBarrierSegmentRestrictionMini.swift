import Foundation

/// A mini representation of
/// a segment restriction object for
/// the shield information barrier
public class ShieldInformationBarrierSegmentRestrictionMini: ShieldInformationBarrierSegmentRestrictionBase {
    private enum CodingKeys: String, CodingKey {
        case shieldInformationBarrierSegment = "shield_information_barrier_segment"
        case restrictedSegment = "restricted_segment"
    }

    /// The `type` and `id` of the
    /// requested shield information barrier segment.
    public let shieldInformationBarrierSegment: ShieldInformationBarrierSegmentRestrictionMiniShieldInformationBarrierSegmentField

    /// The `type` and `id` of the
    /// restricted shield information barrier segment.
    public let restrictedSegment: ShieldInformationBarrierSegmentRestrictionMiniRestrictedSegmentField

    /// Initializer for a ShieldInformationBarrierSegmentRestrictionMini.
    ///
    /// - Parameters:
    ///   - shieldInformationBarrierSegment: The `type` and `id` of the
    ///     requested shield information barrier segment.
    ///   - restrictedSegment: The `type` and `id` of the
    ///     restricted shield information barrier segment.
    ///   - type: Shield information barrier segment restriction
    ///   - id: The unique identifier for the
    ///     shield information barrier segment restriction.
    public init(shieldInformationBarrierSegment: ShieldInformationBarrierSegmentRestrictionMiniShieldInformationBarrierSegmentField, restrictedSegment: ShieldInformationBarrierSegmentRestrictionMiniRestrictedSegmentField, type: ShieldInformationBarrierSegmentRestrictionBaseTypeField? = nil, id: String? = nil) {
        self.shieldInformationBarrierSegment = shieldInformationBarrierSegment
        self.restrictedSegment = restrictedSegment

        super.init(type: type, id: id)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        shieldInformationBarrierSegment = try container.decode(ShieldInformationBarrierSegmentRestrictionMiniShieldInformationBarrierSegmentField.self, forKey: .shieldInformationBarrierSegment)
        restrictedSegment = try container.decode(ShieldInformationBarrierSegmentRestrictionMiniRestrictedSegmentField.self, forKey: .restrictedSegment)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(shieldInformationBarrierSegment, forKey: .shieldInformationBarrierSegment)
        try container.encode(restrictedSegment, forKey: .restrictedSegment)
        try super.encode(to: encoder)
    }

}
