import Foundation

/// The request body used to update an existing shuttle path mapping. Only the
/// fields supplied in the request body are changed. `job_id`, `id`, and `type`
/// are immutable.
public class ShuttlePathMappingUpdateRequestV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case isPathSkipped = "is_path_skipped"
        case source
        case target
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Whether this source path should be skipped during the migration.
    public let isPathSkipped: Bool?

    public let source: ShuttlePathMappingLocationInputV2026R0?

    /// The destination location to migrate to. Set to `null` to clear the
    /// destination, for example when skipping the source path.
    public let target: ShuttlePathMappingTargetLocationInputV2026R0?

    /// Initializer for a ShuttlePathMappingUpdateRequestV2026R0.
    ///
    /// - Parameters:
    ///   - isPathSkipped: Whether this source path should be skipped during the migration.
    ///   - source: 
    ///   - target: The destination location to migrate to. Set to `null` to clear the
    ///     destination, for example when skipping the source path.
    public init(isPathSkipped: Bool? = nil, source: ShuttlePathMappingLocationInputV2026R0? = nil, target: ShuttlePathMappingTargetLocationInputV2026R0? = nil) {
        self.isPathSkipped = isPathSkipped
        self.source = source
        self.target = target
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isPathSkipped = try container.decodeIfPresent(Bool.self, forKey: .isPathSkipped)
        source = try container.decodeIfPresent(ShuttlePathMappingLocationInputV2026R0.self, forKey: .source)
        target = try container.decodeIfPresent(ShuttlePathMappingTargetLocationInputV2026R0.self, forKey: .target)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(isPathSkipped, forKey: .isPathSkipped)
        try container.encodeIfPresent(source, forKey: .source)
        try container.encodeIfPresent(target, forKey: .target)
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
