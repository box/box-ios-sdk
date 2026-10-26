import Foundation

/// The request body used to create a new shuttle job.
public class ShuttleJobCreateRequestV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case name
        case jobType = "job_type"
        case sourceSystemId = "source_system_id"
        case comment
        case tags
        case accountMapping = "account_mapping"
        case settings
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The human-readable name of the shuttle job.
    public let name: String

    /// The type of work the shuttle job performs.
    public let jobType: ShuttleJobCreateRequestV2026R0JobTypeField

    /// The unique identifier of the source system to migrate from.
    public let sourceSystemId: String

    /// An optional free-form comment describing the shuttle job.
    public let comment: String?

    /// A list of free-form tags associated with the shuttle job.
    public let tags: [String]?

    /// The account mapping configuration that controls how source identities
    /// and permissions are translated into Box. When this object is omitted,
    /// the job is created with `is_enabled` set to `false`.
    public let accountMapping: ShuttleJobCreateRequestV2026R0AccountMappingField?

    /// The tunable settings that control how the shuttle job runs.
    public let settings: ShuttleJobCreateRequestV2026R0SettingsField?

    /// Initializer for a ShuttleJobCreateRequestV2026R0.
    ///
    /// - Parameters:
    ///   - name: The human-readable name of the shuttle job.
    ///   - jobType: The type of work the shuttle job performs.
    ///   - sourceSystemId: The unique identifier of the source system to migrate from.
    ///   - comment: An optional free-form comment describing the shuttle job.
    ///   - tags: A list of free-form tags associated with the shuttle job.
    ///   - accountMapping: The account mapping configuration that controls how source identities
    ///     and permissions are translated into Box. When this object is omitted,
    ///     the job is created with `is_enabled` set to `false`.
    ///   - settings: The tunable settings that control how the shuttle job runs.
    public init(name: String, jobType: ShuttleJobCreateRequestV2026R0JobTypeField, sourceSystemId: String, comment: String? = nil, tags: [String]? = nil, accountMapping: ShuttleJobCreateRequestV2026R0AccountMappingField? = nil, settings: ShuttleJobCreateRequestV2026R0SettingsField? = nil) {
        self.name = name
        self.jobType = jobType
        self.sourceSystemId = sourceSystemId
        self.comment = comment
        self.tags = tags
        self.accountMapping = accountMapping
        self.settings = settings
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        jobType = try container.decode(ShuttleJobCreateRequestV2026R0JobTypeField.self, forKey: .jobType)
        sourceSystemId = try container.decode(String.self, forKey: .sourceSystemId)
        comment = try container.decodeIfPresent(String.self, forKey: .comment)
        tags = try container.decodeIfPresent([String].self, forKey: .tags)
        accountMapping = try container.decodeIfPresent(ShuttleJobCreateRequestV2026R0AccountMappingField.self, forKey: .accountMapping)
        settings = try container.decodeIfPresent(ShuttleJobCreateRequestV2026R0SettingsField.self, forKey: .settings)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(jobType, forKey: .jobType)
        try container.encode(sourceSystemId, forKey: .sourceSystemId)
        try container.encodeIfPresent(comment, forKey: .comment)
        try container.encodeIfPresent(tags, forKey: .tags)
        try container.encodeIfPresent(accountMapping, forKey: .accountMapping)
        try container.encodeIfPresent(settings, forKey: .settings)
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
