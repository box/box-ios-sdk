import Foundation

/// A shield information barrier reference for requests and responses
public class ShieldInformationBarrierReference: Codable {
    private enum CodingKeys: String, CodingKey {
        case shieldInformationBarrier = "shield_information_barrier"
    }

    public let shieldInformationBarrier: ShieldInformationBarrierBase?

    public init(shieldInformationBarrier: ShieldInformationBarrierBase? = nil) {
        self.shieldInformationBarrier = shieldInformationBarrier
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        shieldInformationBarrier = try container.decodeIfPresent(ShieldInformationBarrierBase.self, forKey: .shieldInformationBarrier)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(shieldInformationBarrier, forKey: .shieldInformationBarrier)
    }

}
