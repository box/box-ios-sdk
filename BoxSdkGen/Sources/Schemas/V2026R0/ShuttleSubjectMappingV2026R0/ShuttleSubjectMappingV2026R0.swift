import Foundation

/// A standard representation of a shuttle subject mapping. A subject mapping
/// connects a discovered source subject to a Box user or group, or marks the
/// subject as skipped.
public class ShuttleSubjectMappingV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case jobId = "job_id"
        case isSubjectSkipped = "is_subject_skipped"
        case source
        case type
        case discoveredSubjectId = "discovered_subject_id"
        case revision
        case target
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The unique identifier for the shuttle subject mapping.
    public let id: String

    /// The unique identifier of the shuttle job this mapping belongs to.
    public let jobId: String

    /// Whether this subject is skipped during the migration.
    public let isSubjectSkipped: Bool

    public let source: ShuttleSubjectV2026R0

    /// The value will always be `shuttle_subject_mapping`.
    public let type: ShuttleSubjectMappingV2026R0TypeField

    /// The unique identifier of the discovered subject this mapping applies to.
    /// `null` for legacy mappings created before this field was tracked.
    @CodableTriState public private(set) var discoveredSubjectId: String?

    /// The discovery-requirements revision this mapping was resolved against.
    /// `null` for legacy mappings.
    @CodableTriState public private(set) var revision: Int?

    /// The Box target subject. `null` when the subject is skipped or not yet
    /// assigned.
    public let target: ShuttleTargetSubjectV2026R0?

    /// Initializer for a ShuttleSubjectMappingV2026R0.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the shuttle subject mapping.
    ///   - jobId: The unique identifier of the shuttle job this mapping belongs to.
    ///   - isSubjectSkipped: Whether this subject is skipped during the migration.
    ///   - source: 
    ///   - type: The value will always be `shuttle_subject_mapping`.
    ///   - discoveredSubjectId: The unique identifier of the discovered subject this mapping applies to.
    ///     `null` for legacy mappings created before this field was tracked.
    ///   - revision: The discovery-requirements revision this mapping was resolved against.
    ///     `null` for legacy mappings.
    ///   - target: The Box target subject. `null` when the subject is skipped or not yet
    ///     assigned.
    public init(id: String, jobId: String, isSubjectSkipped: Bool, source: ShuttleSubjectV2026R0, type: ShuttleSubjectMappingV2026R0TypeField = ShuttleSubjectMappingV2026R0TypeField.shuttleSubjectMapping, discoveredSubjectId: TriStateField<String> = nil, revision: TriStateField<Int> = nil, target: ShuttleTargetSubjectV2026R0? = nil) {
        self.id = id
        self.jobId = jobId
        self.isSubjectSkipped = isSubjectSkipped
        self.source = source
        self.type = type
        self._discoveredSubjectId = CodableTriState(state: discoveredSubjectId)
        self._revision = CodableTriState(state: revision)
        self.target = target
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        jobId = try container.decode(String.self, forKey: .jobId)
        isSubjectSkipped = try container.decode(Bool.self, forKey: .isSubjectSkipped)
        source = try container.decode(ShuttleSubjectV2026R0.self, forKey: .source)
        type = try container.decode(ShuttleSubjectMappingV2026R0TypeField.self, forKey: .type)
        discoveredSubjectId = try container.decodeIfPresent(String.self, forKey: .discoveredSubjectId)
        revision = try container.decodeIfPresent(Int.self, forKey: .revision)
        target = try container.decodeIfPresent(ShuttleTargetSubjectV2026R0.self, forKey: .target)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(jobId, forKey: .jobId)
        try container.encode(isSubjectSkipped, forKey: .isSubjectSkipped)
        try container.encode(source, forKey: .source)
        try container.encode(type, forKey: .type)
        try container.encode(field: _discoveredSubjectId.state, forKey: .discoveredSubjectId)
        try container.encode(field: _revision.state, forKey: .revision)
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
