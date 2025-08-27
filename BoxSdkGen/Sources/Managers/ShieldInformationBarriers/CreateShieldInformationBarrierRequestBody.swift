import Foundation

public class CreateShieldInformationBarrierRequestBody: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case enterprise
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The `type` and `id` of enterprise this barrier is under.
    public let enterprise: EnterpriseBase

    /// Initializer for a CreateShieldInformationBarrierRequestBody.
    ///
    /// - Parameters:
    ///   - enterprise: The `type` and `id` of enterprise this barrier is under.
    public init(enterprise: EnterpriseBase) {
        self.enterprise = enterprise
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        enterprise = try container.decode(EnterpriseBase.self, forKey: .enterprise)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(enterprise, forKey: .enterprise)
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
