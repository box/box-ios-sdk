import Foundation

/// Multi-status response containing the result for each external user deletion request.
public class ExternalUsersSubmitDeleteJobResponseV2025R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case entries
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Array of results of each external user deletion request.
    public let entries: [ExternalUserDeletionResultV2025R0]

    /// Initializer for a ExternalUsersSubmitDeleteJobResponseV2025R0.
    ///
    /// - Parameters:
    ///   - entries: Array of results of each external user deletion request.
    public init(entries: [ExternalUserDeletionResultV2025R0]) {
        self.entries = entries
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        entries = try container.decode([ExternalUserDeletionResultV2025R0].self, forKey: .entries)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(entries, forKey: .entries)
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
