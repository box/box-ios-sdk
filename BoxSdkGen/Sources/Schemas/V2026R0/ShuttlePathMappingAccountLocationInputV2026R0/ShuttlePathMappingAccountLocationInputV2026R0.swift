import Foundation

/// An account-scoped source location supplied when creating or updating a path
/// mapping.
public class ShuttlePathMappingAccountLocationInputV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case path
        case account
        case type
        case pathId = "path_id"
        case isDirectory = "is_directory"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The human-readable path relative to the account root.
    public let path: String

    public let account: ShuttlePathMappingAccountInputV2026R0

    /// The value will always be `account`.
    public let type: ShuttlePathMappingAccountLocationInputV2026R0TypeField

    /// An optional stable identifier of the location, when obtained from
    /// browsing.
    public let pathId: String?

    /// Whether the location is a directory. When set, the destination must be
    /// the same kind of object.
    public let isDirectory: Bool?

    /// Initializer for a ShuttlePathMappingAccountLocationInputV2026R0.
    ///
    /// - Parameters:
    ///   - path: The human-readable path relative to the account root.
    ///   - account: 
    ///   - type: The value will always be `account`.
    ///   - pathId: An optional stable identifier of the location, when obtained from
    ///     browsing.
    ///   - isDirectory: Whether the location is a directory. When set, the destination must be
    ///     the same kind of object.
    public init(path: String, account: ShuttlePathMappingAccountInputV2026R0, type: ShuttlePathMappingAccountLocationInputV2026R0TypeField = ShuttlePathMappingAccountLocationInputV2026R0TypeField.account, pathId: String? = nil, isDirectory: Bool? = nil) {
        self.path = path
        self.account = account
        self.type = type
        self.pathId = pathId
        self.isDirectory = isDirectory
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        path = try container.decode(String.self, forKey: .path)
        account = try container.decode(ShuttlePathMappingAccountInputV2026R0.self, forKey: .account)
        type = try container.decode(ShuttlePathMappingAccountLocationInputV2026R0TypeField.self, forKey: .type)
        pathId = try container.decodeIfPresent(String.self, forKey: .pathId)
        isDirectory = try container.decodeIfPresent(Bool.self, forKey: .isDirectory)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(path, forKey: .path)
        try container.encode(account, forKey: .account)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(pathId, forKey: .pathId)
        try container.encodeIfPresent(isDirectory, forKey: .isDirectory)
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
