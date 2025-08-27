import Foundation

public class TerminateGroupsSessionsRequestBody: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case groupIds = "group_ids"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// A list of group IDs.
    public let groupIds: [String]

    /// Initializer for a TerminateGroupsSessionsRequestBody.
    ///
    /// - Parameters:
    ///   - groupIds: A list of group IDs.
    public init(groupIds: [String]) {
        self.groupIds = groupIds
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        groupIds = try container.decode([String].self, forKey: .groupIds)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(groupIds, forKey: .groupIds)
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
