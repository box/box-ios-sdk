import Foundation

/// A subject discovered on the source system during a scan, with an optional
/// suggested Box target.
public class ShuttleDiscoveredSubjectV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case jobId = "job_id"
        case revision
        case source
        case type
        case suggestedTarget = "suggested_target"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The unique identifier for the discovered subject.
    public let id: String

    /// The unique identifier of the shuttle job this subject belongs to.
    public let jobId: String

    /// The scan revision this discovered subject belongs to.
    public let revision: Int

    public let source: ShuttleSubjectV2026R0

    /// The value will always be `shuttle_discovered_subject`.
    public let type: ShuttleDiscoveredSubjectV2026R0TypeField

    /// A suggested Box target inferred during the scan. `null` when no
    /// suggestion was made.
    public let suggestedTarget: ShuttleTargetSubjectV2026R0?

    /// Initializer for a ShuttleDiscoveredSubjectV2026R0.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the discovered subject.
    ///   - jobId: The unique identifier of the shuttle job this subject belongs to.
    ///   - revision: The scan revision this discovered subject belongs to.
    ///   - source: 
    ///   - type: The value will always be `shuttle_discovered_subject`.
    ///   - suggestedTarget: A suggested Box target inferred during the scan. `null` when no
    ///     suggestion was made.
    public init(id: String, jobId: String, revision: Int, source: ShuttleSubjectV2026R0, type: ShuttleDiscoveredSubjectV2026R0TypeField = ShuttleDiscoveredSubjectV2026R0TypeField.shuttleDiscoveredSubject, suggestedTarget: ShuttleTargetSubjectV2026R0? = nil) {
        self.id = id
        self.jobId = jobId
        self.revision = revision
        self.source = source
        self.type = type
        self.suggestedTarget = suggestedTarget
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        jobId = try container.decode(String.self, forKey: .jobId)
        revision = try container.decode(Int.self, forKey: .revision)
        source = try container.decode(ShuttleSubjectV2026R0.self, forKey: .source)
        type = try container.decode(ShuttleDiscoveredSubjectV2026R0TypeField.self, forKey: .type)
        suggestedTarget = try container.decodeIfPresent(ShuttleTargetSubjectV2026R0.self, forKey: .suggestedTarget)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(jobId, forKey: .jobId)
        try container.encode(revision, forKey: .revision)
        try container.encode(source, forKey: .source)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(suggestedTarget, forKey: .suggestedTarget)
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
