import Foundation

/// A path mapping location scoped to a user or service account.
public class ShuttlePathMappingAccountLocationV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case path
        case type
        case pathId = "path_id"
        case account
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

    /// The value will always be `account`.
    public let type: ShuttlePathMappingAccountLocationV2026R0TypeField

    /// The stable identifier of the location. `null` when the system does not
    /// provide one.
    @CodableTriState public private(set) var pathId: String?

    public let account: ShuttlePathMappingAccountV2026R0?

    /// Whether the location is a directory. `null` when unknown.
    @CodableTriState public private(set) var isDirectory: Bool?

    /// Initializer for a ShuttlePathMappingAccountLocationV2026R0.
    ///
    /// - Parameters:
    ///   - path: The human-readable path relative to the account root.
    ///   - type: The value will always be `account`.
    ///   - pathId: The stable identifier of the location. `null` when the system does not
    ///     provide one.
    ///   - account: 
    ///   - isDirectory: Whether the location is a directory. `null` when unknown.
    public init(path: String, type: ShuttlePathMappingAccountLocationV2026R0TypeField = ShuttlePathMappingAccountLocationV2026R0TypeField.account, pathId: TriStateField<String> = nil, account: ShuttlePathMappingAccountV2026R0? = nil, isDirectory: TriStateField<Bool> = nil) {
        self.path = path
        self.type = type
        self._pathId = CodableTriState(state: pathId)
        self.account = account
        self._isDirectory = CodableTriState(state: isDirectory)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        path = try container.decode(String.self, forKey: .path)
        type = try container.decode(ShuttlePathMappingAccountLocationV2026R0TypeField.self, forKey: .type)
        pathId = try container.decodeIfPresent(String.self, forKey: .pathId)
        account = try container.decodeIfPresent(ShuttlePathMappingAccountV2026R0.self, forKey: .account)
        isDirectory = try container.decodeIfPresent(Bool.self, forKey: .isDirectory)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(path, forKey: .path)
        try container.encode(type, forKey: .type)
        try container.encode(field: _pathId.state, forKey: .pathId)
        try container.encodeIfPresent(account, forKey: .account)
        try container.encode(field: _isDirectory.state, forKey: .isDirectory)
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
