import Foundation

/// The request body used to create a new shuttle subject mapping.
public class ShuttleSubjectMappingCreateRequestV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case jobId = "job_id"
        case discoveredSubjectId = "discovered_subject_id"
        case revision
        case isSubjectSkipped = "is_subject_skipped"
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

    /// The unique identifier of the discovered subject to map.
    public let discoveredSubjectId: String

    /// The discovery-requirements revision to resolve against. Omit to use the
    /// latest revision.
    public let revision: Int?

    /// Whether this subject should be skipped during the migration. Defaults
    /// to `false`.
    public let isSubjectSkipped: Bool?

    /// The Box target to map to. Omit or set to `null` when the subject is
    /// skipped.
    public let target: ShuttleTargetSubjectInputV2026R0?

    /// Initializer for a ShuttleSubjectMappingCreateRequestV2026R0.
    ///
    /// - Parameters:
    ///   - jobId: The unique identifier of the shuttle job this mapping belongs to.
    ///   - discoveredSubjectId: The unique identifier of the discovered subject to map.
    ///   - revision: The discovery-requirements revision to resolve against. Omit to use the
    ///     latest revision.
    ///   - isSubjectSkipped: Whether this subject should be skipped during the migration. Defaults
    ///     to `false`.
    ///   - target: The Box target to map to. Omit or set to `null` when the subject is
    ///     skipped.
    public init(jobId: String, discoveredSubjectId: String, revision: Int? = nil, isSubjectSkipped: Bool? = nil, target: ShuttleTargetSubjectInputV2026R0? = nil) {
        self.jobId = jobId
        self.discoveredSubjectId = discoveredSubjectId
        self.revision = revision
        self.isSubjectSkipped = isSubjectSkipped
        self.target = target
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        jobId = try container.decode(String.self, forKey: .jobId)
        discoveredSubjectId = try container.decode(String.self, forKey: .discoveredSubjectId)
        revision = try container.decodeIfPresent(Int.self, forKey: .revision)
        isSubjectSkipped = try container.decodeIfPresent(Bool.self, forKey: .isSubjectSkipped)
        target = try container.decodeIfPresent(ShuttleTargetSubjectInputV2026R0.self, forKey: .target)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(jobId, forKey: .jobId)
        try container.encode(discoveredSubjectId, forKey: .discoveredSubjectId)
        try container.encodeIfPresent(revision, forKey: .revision)
        try container.encodeIfPresent(isSubjectSkipped, forKey: .isSubjectSkipped)
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
