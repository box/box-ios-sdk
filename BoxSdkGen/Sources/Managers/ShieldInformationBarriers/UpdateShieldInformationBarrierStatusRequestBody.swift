import Foundation

public class UpdateShieldInformationBarrierStatusRequestBody: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case status
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The ID of the shield information barrier.
    public let id: String

    /// The desired status for the shield information barrier.
    public let status: UpdateShieldInformationBarrierStatusRequestBodyStatusField

    /// Initializer for a UpdateShieldInformationBarrierStatusRequestBody.
    ///
    /// - Parameters:
    ///   - id: The ID of the shield information barrier.
    ///   - status: The desired status for the shield information barrier.
    public init(id: String, status: UpdateShieldInformationBarrierStatusRequestBodyStatusField) {
        self.id = id
        self.status = status
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        status = try container.decode(UpdateShieldInformationBarrierStatusRequestBodyStatusField.self, forKey: .status)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(status, forKey: .status)
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
