import Foundation

/// A base representation of
/// a segment restriction object for
/// the shield information barrier
public class ShieldInformationBarrierSegmentRestrictionBase: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
        case id
    }

    /// Shield information barrier segment restriction
    public let type: ShieldInformationBarrierSegmentRestrictionBaseTypeField?

    /// The unique identifier for the
    /// shield information barrier segment restriction.
    public let id: String?

    /// Initializer for a ShieldInformationBarrierSegmentRestrictionBase.
    ///
    /// - Parameters:
    ///   - type: Shield information barrier segment restriction
    ///   - id: The unique identifier for the
    ///     shield information barrier segment restriction.
    public init(type: ShieldInformationBarrierSegmentRestrictionBaseTypeField? = nil, id: String? = nil) {
        self.type = type
        self.id = id
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(ShieldInformationBarrierSegmentRestrictionBaseTypeField.self, forKey: .type)
        id = try container.decodeIfPresent(String.self, forKey: .id)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(id, forKey: .id)
    }

}
