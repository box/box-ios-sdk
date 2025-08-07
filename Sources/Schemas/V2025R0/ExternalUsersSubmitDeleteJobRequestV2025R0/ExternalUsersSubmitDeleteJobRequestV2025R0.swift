import Foundation

/// Request to submit a job to delete external users from the current enterprise.
public class ExternalUsersSubmitDeleteJobRequestV2025R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case externalUsers = "external_users"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// List of external users to delete.
    public let externalUsers: [UserReferenceV2025R0]

    /// Initializer for a ExternalUsersSubmitDeleteJobRequestV2025R0.
    ///
    /// - Parameters:
    ///   - externalUsers: List of external users to delete.
    public init(externalUsers: [UserReferenceV2025R0]) {
        self.externalUsers = externalUsers
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        externalUsers = try container.decode([UserReferenceV2025R0].self, forKey: .externalUsers)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(externalUsers, forKey: .externalUsers)
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
