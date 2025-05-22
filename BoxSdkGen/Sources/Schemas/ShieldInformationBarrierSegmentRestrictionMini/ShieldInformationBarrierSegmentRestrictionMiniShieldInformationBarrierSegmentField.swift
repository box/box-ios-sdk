import Foundation

public class ShieldInformationBarrierSegmentRestrictionMiniShieldInformationBarrierSegmentField: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// The ID reference of the
    /// requesting shield information barrier segment.
    public let id: String?

    /// The type of the shield information barrier segment
    public let type: ShieldInformationBarrierSegmentRestrictionMiniShieldInformationBarrierSegmentTypeField?

    /// Initializer for a ShieldInformationBarrierSegmentRestrictionMiniShieldInformationBarrierSegmentField.
    ///
    /// - Parameters:
    ///   - id: The ID reference of the
    ///     requesting shield information barrier segment.
    ///   - type: The type of the shield information barrier segment
    public init(id: String? = nil, type: ShieldInformationBarrierSegmentRestrictionMiniShieldInformationBarrierSegmentTypeField? = nil) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decodeIfPresent(ShieldInformationBarrierSegmentRestrictionMiniShieldInformationBarrierSegmentTypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
    }

}
