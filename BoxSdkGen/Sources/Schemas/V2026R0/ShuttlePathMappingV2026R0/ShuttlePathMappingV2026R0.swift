import Foundation

/// A standard representation of a shuttle path mapping. A path mapping
/// connects a source location on the migrated system to a destination in Box,
/// or marks the source path as skipped.
public class ShuttlePathMappingV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case jobId = "job_id"
        case isPathSkipped = "is_path_skipped"
        case source
        case type
        case target
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The unique identifier for the shuttle path mapping.
    public let id: String

    /// The unique identifier of the shuttle job this mapping belongs to.
    public let jobId: String

    /// Whether this source path is skipped during the migration.
    public let isPathSkipped: Bool

    public let source: ShuttlePathMappingLocationV2026R0

    /// The value will always be `shuttle_path_mapping`.
    public let type: ShuttlePathMappingV2026R0TypeField

    /// The destination location. `null` when the source path is skipped or
    /// the job has no destination, such as an analysis job.
    public let target: ShuttlePathMappingLocationV2026R0?

    /// Initializer for a ShuttlePathMappingV2026R0.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the shuttle path mapping.
    ///   - jobId: The unique identifier of the shuttle job this mapping belongs to.
    ///   - isPathSkipped: Whether this source path is skipped during the migration.
    ///   - source: 
    ///   - type: The value will always be `shuttle_path_mapping`.
    ///   - target: The destination location. `null` when the source path is skipped or
    ///     the job has no destination, such as an analysis job.
    public init(id: String, jobId: String, isPathSkipped: Bool, source: ShuttlePathMappingLocationV2026R0, type: ShuttlePathMappingV2026R0TypeField = ShuttlePathMappingV2026R0TypeField.shuttlePathMapping, target: ShuttlePathMappingLocationV2026R0? = nil) {
        self.id = id
        self.jobId = jobId
        self.isPathSkipped = isPathSkipped
        self.source = source
        self.type = type
        self.target = target
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        jobId = try container.decode(String.self, forKey: .jobId)
        isPathSkipped = try container.decode(Bool.self, forKey: .isPathSkipped)
        source = try container.decode(ShuttlePathMappingLocationV2026R0.self, forKey: .source)
        type = try container.decode(ShuttlePathMappingV2026R0TypeField.self, forKey: .type)
        target = try container.decodeIfPresent(ShuttlePathMappingLocationV2026R0.self, forKey: .target)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(jobId, forKey: .jobId)
        try container.encode(isPathSkipped, forKey: .isPathSkipped)
        try container.encode(source, forKey: .source)
        try container.encode(type, forKey: .type)
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
