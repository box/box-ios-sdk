import Foundation

/// The request body used to create a new shuttle path mapping.
public class ShuttlePathMappingCreateRequestV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case jobId = "job_id"
        case source
        case isPathSkipped = "is_path_skipped"
        case target
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The unique identifier of the shuttle job this mapping belongs to.
    public let jobId: String

    public let source: ShuttlePathMappingLocationInputV2026R0

    /// Whether this source path should be skipped during the migration.
    /// Defaults to `false`.
    public let isPathSkipped: Bool?

    /// The destination location to migrate to. Omit or set to `null` when the
    /// source path is skipped.
    public let target: ShuttlePathMappingTargetLocationInputV2026R0?

    /// Initializer for a ShuttlePathMappingCreateRequestV2026R0.
    ///
    /// - Parameters:
    ///   - jobId: The unique identifier of the shuttle job this mapping belongs to.
    ///   - source: 
    ///   - isPathSkipped: Whether this source path should be skipped during the migration.
    ///     Defaults to `false`.
    ///   - target: The destination location to migrate to. Omit or set to `null` when the
    ///     source path is skipped.
    public init(jobId: String, source: ShuttlePathMappingLocationInputV2026R0, isPathSkipped: Bool? = nil, target: ShuttlePathMappingTargetLocationInputV2026R0? = nil) {
        self.jobId = jobId
        self.source = source
        self.isPathSkipped = isPathSkipped
        self.target = target
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        jobId = try container.decode(String.self, forKey: .jobId)
        source = try container.decode(ShuttlePathMappingLocationInputV2026R0.self, forKey: .source)
        isPathSkipped = try container.decodeIfPresent(Bool.self, forKey: .isPathSkipped)
        target = try container.decodeIfPresent(ShuttlePathMappingTargetLocationInputV2026R0.self, forKey: .target)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(jobId, forKey: .jobId)
        try container.encode(source, forKey: .source)
        try container.encodeIfPresent(isPathSkipped, forKey: .isPathSkipped)
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
