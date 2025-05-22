import Foundation

/// A base representation of a
/// shield information barrier object
public class ShieldInformationBarrierBase: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// The unique identifier for the shield information barrier
    public let id: String?

    /// The type of the shield information barrier
    public let type: ShieldInformationBarrierBaseTypeField?

    /// Initializer for a ShieldInformationBarrierBase.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the shield information barrier
    ///   - type: The type of the shield information barrier
    public init(id: String? = nil, type: ShieldInformationBarrierBaseTypeField? = nil) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decodeIfPresent(ShieldInformationBarrierBaseTypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
    }

}
