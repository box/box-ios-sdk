import Foundation

public class CreateShieldInformationBarrierSegmentRequestBody: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case shieldInformationBarrier = "shield_information_barrier"
        case name
        case description
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    public let shieldInformationBarrier: ShieldInformationBarrierBase

    /// Name of the shield information barrier segment.
    public let name: String

    /// Description of the shield information barrier segment.
    public let description: String?

    /// Initializer for a CreateShieldInformationBarrierSegmentRequestBody.
    ///
    /// - Parameters:
    ///   - shieldInformationBarrier: 
    ///   - name: Name of the shield information barrier segment.
    ///   - description: Description of the shield information barrier segment.
    public init(shieldInformationBarrier: ShieldInformationBarrierBase, name: String, description: String? = nil) {
        self.shieldInformationBarrier = shieldInformationBarrier
        self.name = name
        self.description = description
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        shieldInformationBarrier = try container.decode(ShieldInformationBarrierBase.self, forKey: .shieldInformationBarrier)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(shieldInformationBarrier, forKey: .shieldInformationBarrier)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(description, forKey: .description)
    }

    /// Sets the raw JSON data.
    ///
    /// - Parameters:
    ///   - rawData: A dictionary containing the raw JSON data
    func setRawData(rawData: [String: Any]?) {
        self._rawData = rawData
    }

    /// Gets the raw JSON data
    /// - Returns: The `[String: Any]?`.
    func getRawData() -> [String: Any]? {
        return self._rawData
    }

}
