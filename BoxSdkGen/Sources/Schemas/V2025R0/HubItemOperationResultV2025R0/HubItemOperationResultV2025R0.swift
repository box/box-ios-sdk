import Foundation

/// Result of a Box Hub item operation.
public class HubItemOperationResultV2025R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case action
        case item
        case status
        case error
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The action performed on the item.
    public let action: String?

    public let item: HubItemReferenceV2025R0?

    /// The HTTP status code of the operation.
    public let status: Int64?

    /// Error message if the operation failed.
    public let error: String?

    /// Initializer for a HubItemOperationResultV2025R0.
    ///
    /// - Parameters:
    ///   - action: The action performed on the item.
    ///   - item: 
    ///   - status: The HTTP status code of the operation.
    ///   - error: Error message if the operation failed.
    public init(action: String? = nil, item: HubItemReferenceV2025R0? = nil, status: Int64? = nil, error: String? = nil) {
        self.action = action
        self.item = item
        self.status = status
        self.error = error
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        action = try container.decodeIfPresent(String.self, forKey: .action)
        item = try container.decodeIfPresent(HubItemReferenceV2025R0.self, forKey: .item)
        status = try container.decodeIfPresent(Int64.self, forKey: .status)
        error = try container.decodeIfPresent(String.self, forKey: .error)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(action, forKey: .action)
        try container.encodeIfPresent(item, forKey: .item)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeIfPresent(error, forKey: .error)
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
