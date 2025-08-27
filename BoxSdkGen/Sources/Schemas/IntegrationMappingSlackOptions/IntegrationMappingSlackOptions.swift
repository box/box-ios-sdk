import Foundation

/// The schema for an integration mapping options object for Slack type.
public class IntegrationMappingSlackOptions: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case isAccessManagementDisabled = "is_access_management_disabled"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Indicates whether or not channel member
    /// access to the underlying box item
    /// should be automatically managed.
    /// Depending on type of channel, access is managed
    /// through creating collaborations or shared links.
    public let isAccessManagementDisabled: Bool?

    /// Initializer for a IntegrationMappingSlackOptions.
    ///
    /// - Parameters:
    ///   - isAccessManagementDisabled: Indicates whether or not channel member
    ///     access to the underlying box item
    ///     should be automatically managed.
    ///     Depending on type of channel, access is managed
    ///     through creating collaborations or shared links.
    public init(isAccessManagementDisabled: Bool? = nil) {
        self.isAccessManagementDisabled = isAccessManagementDisabled
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isAccessManagementDisabled = try container.decodeIfPresent(Bool.self, forKey: .isAccessManagementDisabled)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(isAccessManagementDisabled, forKey: .isAccessManagementDisabled)
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
