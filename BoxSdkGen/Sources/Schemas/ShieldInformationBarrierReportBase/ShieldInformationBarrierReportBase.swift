import Foundation

/// A base representation of a
/// shield information barrier report object
public class ShieldInformationBarrierReportBase: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// The unique identifier for the shield information barrier report
    public let id: String?

    /// The type of the shield information barrier report
    public let type: ShieldInformationBarrierReportBaseTypeField?

    /// Initializer for a ShieldInformationBarrierReportBase.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the shield information barrier report
    ///   - type: The type of the shield information barrier report
    public init(id: String? = nil, type: ShieldInformationBarrierReportBaseTypeField? = nil) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decodeIfPresent(ShieldInformationBarrierReportBaseTypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
    }

}
