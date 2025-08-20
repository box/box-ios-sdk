import Foundation

/// Result of a single external user deletion request.
public class ExternalUserDeletionResultV2025R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case status
        case detail
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The ID of the external user.
    public let userId: String

    /// HTTP status code for a specific user's deletion request.
    public let status: Int64

    /// Deletion request status details.
    public let detail: String?

    /// Initializer for a ExternalUserDeletionResultV2025R0.
    ///
    /// - Parameters:
    ///   - userId: The ID of the external user.
    ///   - status: HTTP status code for a specific user's deletion request.
    ///   - detail: Deletion request status details.
    public init(userId: String, status: Int64, detail: String? = nil) {
        self.userId = userId
        self.status = status
        self.detail = detail
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userId = try container.decode(String.self, forKey: .userId)
        status = try container.decode(Int64.self, forKey: .status)
        detail = try container.decodeIfPresent(String.self, forKey: .detail)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userId, forKey: .userId)
        try container.encode(status, forKey: .status)
        try container.encodeIfPresent(detail, forKey: .detail)
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
