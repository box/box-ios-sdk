import Foundation

/// A shared-container destination location supplied when creating or updating
/// a path mapping.
public class ShuttlePathMappingSharedSpaceLocationTargetInputV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case path
        case type
        case space
        case pathId = "path_id"
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
    public let type: ShuttlePathMappingSharedSpaceLocationTargetInputV2026R0TypeField

    /// The display name of the shared container. Required for systems with
    /// multiple containers.
    public let space: String?

    /// An optional stable identifier of the location, when obtained from
    /// browsing.
    public let pathId: String?

    /// Initializer for a ShuttlePathMappingSharedSpaceLocationTargetInputV2026R0.
    ///
    /// - Parameters:
    ///   - path: The human-readable path relative to the shared container.
    ///   - type: The value will always be `shared_space`.
    ///   - space: The display name of the shared container. Required for systems with
    ///     multiple containers.
    ///   - pathId: An optional stable identifier of the location, when obtained from
    ///     browsing.
    public init(path: String, type: ShuttlePathMappingSharedSpaceLocationTargetInputV2026R0TypeField = ShuttlePathMappingSharedSpaceLocationTargetInputV2026R0TypeField.sharedSpace, space: String? = nil, pathId: String? = nil) {
        self.path = path
        self.type = type
        self.space = space
        self.pathId = pathId
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        path = try container.decode(String.self, forKey: .path)
        type = try container.decode(ShuttlePathMappingSharedSpaceLocationTargetInputV2026R0TypeField.self, forKey: .type)
        space = try container.decodeIfPresent(String.self, forKey: .space)
        pathId = try container.decodeIfPresent(String.self, forKey: .pathId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(path, forKey: .path)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(space, forKey: .space)
        try container.encodeIfPresent(pathId, forKey: .pathId)
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
