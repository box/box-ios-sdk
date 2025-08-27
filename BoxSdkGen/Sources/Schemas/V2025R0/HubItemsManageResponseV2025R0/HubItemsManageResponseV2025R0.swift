import Foundation

/// Response schema for the status of Hub items management operations.
public class HubItemsManageResponseV2025R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case operations
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// List of operations performed on Hub items.
    public let operations: [HubItemOperationResultV2025R0]

    /// Initializer for a HubItemsManageResponseV2025R0.
    ///
    /// - Parameters:
    ///   - operations: List of operations performed on Hub items.
    public init(operations: [HubItemOperationResultV2025R0]) {
        self.operations = operations
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        operations = try container.decode([HubItemOperationResultV2025R0].self, forKey: .operations)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(operations, forKey: .operations)
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
