import Foundation

/// A path mapping location scoped to a shared container such as a site, team
/// drive, bucket, or file share.
public class ShuttlePathMappingSharedSpaceLocationV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case path
        case type
        case space
        case pathId = "path_id"
        case isDirectory = "is_directory"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The human-readable path relative to the shared container.
    public let path: String

    /// The value will always be `shared_space`.
    public let type: ShuttlePathMappingSharedSpaceLocationV2026R0TypeField

    /// The display name of the shared container. `null` when the system has a
    /// single implicit container.
    @CodableTriState public private(set) var space: String?

    /// The stable identifier of the location. `null` when the system does not
    /// provide one.
    @CodableTriState public private(set) var pathId: String?

    /// Whether the location is a directory. `null` when unknown.
    @CodableTriState public private(set) var isDirectory: Bool?

    /// Initializer for a ShuttlePathMappingSharedSpaceLocationV2026R0.
    ///
    /// - Parameters:
    ///   - path: The human-readable path relative to the shared container.
    ///   - type: The value will always be `shared_space`.
    ///   - space: The display name of the shared container. `null` when the system has a
    ///     single implicit container.
    ///   - pathId: The stable identifier of the location. `null` when the system does not
    ///     provide one.
    ///   - isDirectory: Whether the location is a directory. `null` when unknown.
    public init(path: String, type: ShuttlePathMappingSharedSpaceLocationV2026R0TypeField = ShuttlePathMappingSharedSpaceLocationV2026R0TypeField.sharedSpace, space: TriStateField<String> = nil, pathId: TriStateField<String> = nil, isDirectory: TriStateField<Bool> = nil) {
        self.path = path
        self.type = type
        self._space = CodableTriState(state: space)
        self._pathId = CodableTriState(state: pathId)
        self._isDirectory = CodableTriState(state: isDirectory)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        path = try container.decode(String.self, forKey: .path)
        type = try container.decode(ShuttlePathMappingSharedSpaceLocationV2026R0TypeField.self, forKey: .type)
        space = try container.decodeIfPresent(String.self, forKey: .space)
        pathId = try container.decodeIfPresent(String.self, forKey: .pathId)
        isDirectory = try container.decodeIfPresent(Bool.self, forKey: .isDirectory)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(path, forKey: .path)
        try container.encode(type, forKey: .type)
        try container.encode(field: _space.state, forKey: .space)
        try container.encode(field: _pathId.state, forKey: .pathId)
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
