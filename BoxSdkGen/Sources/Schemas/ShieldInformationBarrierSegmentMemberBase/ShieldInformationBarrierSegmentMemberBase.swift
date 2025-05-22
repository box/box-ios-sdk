import Foundation

/// A base representation of a
/// shield information barrier segment member object
public class ShieldInformationBarrierSegmentMemberBase: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// The unique identifier for the
    /// shield information barrier segment member
    public let id: String?

    /// The type of the shield information barrier segment member
    public let type: ShieldInformationBarrierSegmentMemberBaseTypeField?

    /// Initializer for a ShieldInformationBarrierSegmentMemberBase.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the
    ///     shield information barrier segment member
    ///   - type: The type of the shield information barrier segment member
    public init(id: String? = nil, type: ShieldInformationBarrierSegmentMemberBaseTypeField? = nil) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decodeIfPresent(ShieldInformationBarrierSegmentMemberBaseTypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
    }

}
