import Foundation

/// Device pins allow enterprises to control what devices can
/// use native Box applications.
public class DevicePinner: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case ownedBy = "owned_by"
        case productName = "product_name"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The unique identifier for this device pin.
    public let id: String?

    /// The value will always be `device_pinner`.
    public let type: DevicePinnerTypeField?

    public let ownedBy: UserMini?

    /// The type of device being pinned.
    public let productName: String?

    /// Initializer for a DevicePinner.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this device pin.
    ///   - type: The value will always be `device_pinner`.
    ///   - ownedBy: 
    ///   - productName: The type of device being pinned.
    public init(id: String? = nil, type: DevicePinnerTypeField? = nil, ownedBy: UserMini? = nil, productName: String? = nil) {
        self.id = id
        self.type = type
        self.ownedBy = ownedBy
        self.productName = productName
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decodeIfPresent(DevicePinnerTypeField.self, forKey: .type)
        ownedBy = try container.decodeIfPresent(UserMini.self, forKey: .ownedBy)
        productName = try container.decodeIfPresent(String.self, forKey: .productName)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(ownedBy, forKey: .ownedBy)
        try container.encodeIfPresent(productName, forKey: .productName)
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
