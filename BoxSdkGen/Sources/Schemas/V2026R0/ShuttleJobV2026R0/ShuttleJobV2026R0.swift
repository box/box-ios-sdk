import Foundation

/// A standard representation of a shuttle job. A shuttle job describes a
/// migration of content from a source system into Box, including its current
/// state, mapping-preparation state, and mapping configuration.
public class ShuttleJobV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case jobType = "job_type"
        case state
        case mappingState = "mapping_state"
        case sourceSystem = "source_system"
        case type
        case comment
        case accountMapping = "account_mapping"
        case tags
        case settings
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The unique identifier for the shuttle job.
    public let id: String

    /// The human-readable name of the shuttle job.
    public let name: String

    /// The type of work the shuttle job performs.
    public let jobType: ShuttleJobV2026R0JobTypeField

    /// The current state of the shuttle job. This is an open string whose set
    /// of values is expected to grow; the currently documented values include
    /// `created`, `started`, `stopped`, `completed`, `failed`, `invalid`, and
    /// `unknown`. Clients should treat any value they do not recognize as
    /// `unknown`.
    public let state: String

    /// The current mapping-preparation state of the job. This is an open string
    /// whose set of values is expected to grow; the currently documented values
    /// include `awaiting_path_mapping`, `importing_paths`,
    /// `paths_import_rejected`, `paths_invalid`, `paths_ready`,
    /// `scanning_source`, `source_scan_failed`, `source_scan_out_of_date`,
    /// `awaiting_subject_mapping`, `importing_subjects`,
    /// `subjects_import_rejected`, `mapping_complete`, `building_map`,
    /// `map_build_failed`, `map_out_of_date`, and `ready`.
    /// `paths_import_rejected` means the last path-mapping spreadsheet was
    /// rejected or failed and the path mappings have not been changed since;
    /// it clears on the next import or the next manual path-mapping change.
    /// `subjects_import_rejected` means the last subject-mapping spreadsheet
    /// was rejected or failed and the subject mappings have not been changed
    /// since; it clears on the next import or the next manual subject-mapping
    /// change.
    public let mappingState: String

    /// The source system the shuttle job migrates content from.
    public let sourceSystem: ShuttleJobV2026R0SourceSystemField

    /// The value will always be `shuttle_job`.
    public let type: ShuttleJobV2026R0TypeField

    /// An optional free-form comment describing the shuttle job.
    @CodableTriState public private(set) var comment: String?

    /// The account mapping configuration that controls how source identities
    /// and permissions are translated into Box.
    public let accountMapping: ShuttleJobV2026R0AccountMappingField?

    /// A list of free-form tags associated with the shuttle job.
    public let tags: [String]?

    /// The tunable settings that control how the shuttle job runs.
    public let settings: ShuttleJobV2026R0SettingsField?

    /// Initializer for a ShuttleJobV2026R0.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the shuttle job.
    ///   - name: The human-readable name of the shuttle job.
    ///   - jobType: The type of work the shuttle job performs.
    ///   - state: The current state of the shuttle job. This is an open string whose set
    ///     of values is expected to grow; the currently documented values include
    ///     `created`, `started`, `stopped`, `completed`, `failed`, `invalid`, and
    ///     `unknown`. Clients should treat any value they do not recognize as
    ///     `unknown`.
    ///   - mappingState: The current mapping-preparation state of the job. This is an open string
    ///     whose set of values is expected to grow; the currently documented values
    ///     include `awaiting_path_mapping`, `importing_paths`,
    ///     `paths_import_rejected`, `paths_invalid`, `paths_ready`,
    ///     `scanning_source`, `source_scan_failed`, `source_scan_out_of_date`,
    ///     `awaiting_subject_mapping`, `importing_subjects`,
    ///     `subjects_import_rejected`, `mapping_complete`, `building_map`,
    ///     `map_build_failed`, `map_out_of_date`, and `ready`.
    ///     `paths_import_rejected` means the last path-mapping spreadsheet was
    ///     rejected or failed and the path mappings have not been changed since;
    ///     it clears on the next import or the next manual path-mapping change.
    ///     `subjects_import_rejected` means the last subject-mapping spreadsheet
    ///     was rejected or failed and the subject mappings have not been changed
    ///     since; it clears on the next import or the next manual subject-mapping
    ///     change.
    ///   - sourceSystem: The source system the shuttle job migrates content from.
    ///   - type: The value will always be `shuttle_job`.
    ///   - comment: An optional free-form comment describing the shuttle job.
    ///   - accountMapping: The account mapping configuration that controls how source identities
    ///     and permissions are translated into Box.
    ///   - tags: A list of free-form tags associated with the shuttle job.
    ///   - settings: The tunable settings that control how the shuttle job runs.
    public init(id: String, name: String, jobType: ShuttleJobV2026R0JobTypeField, state: String, mappingState: String, sourceSystem: ShuttleJobV2026R0SourceSystemField, type: ShuttleJobV2026R0TypeField = ShuttleJobV2026R0TypeField.shuttleJob, comment: TriStateField<String> = nil, accountMapping: ShuttleJobV2026R0AccountMappingField? = nil, tags: [String]? = nil, settings: ShuttleJobV2026R0SettingsField? = nil) {
        self.id = id
        self.name = name
        self.jobType = jobType
        self.state = state
        self.mappingState = mappingState
        self.sourceSystem = sourceSystem
        self.type = type
        self._comment = CodableTriState(state: comment)
        self.accountMapping = accountMapping
        self.tags = tags
        self.settings = settings
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        jobType = try container.decode(ShuttleJobV2026R0JobTypeField.self, forKey: .jobType)
        state = try container.decode(String.self, forKey: .state)
        mappingState = try container.decode(String.self, forKey: .mappingState)
        sourceSystem = try container.decode(ShuttleJobV2026R0SourceSystemField.self, forKey: .sourceSystem)
        type = try container.decode(ShuttleJobV2026R0TypeField.self, forKey: .type)
        comment = try container.decodeIfPresent(String.self, forKey: .comment)
        accountMapping = try container.decodeIfPresent(ShuttleJobV2026R0AccountMappingField.self, forKey: .accountMapping)
        tags = try container.decodeIfPresent([String].self, forKey: .tags)
        settings = try container.decodeIfPresent(ShuttleJobV2026R0SettingsField.self, forKey: .settings)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(jobType, forKey: .jobType)
        try container.encode(state, forKey: .state)
        try container.encode(mappingState, forKey: .mappingState)
        try container.encode(sourceSystem, forKey: .sourceSystem)
        try container.encode(type, forKey: .type)
        try container.encode(field: _comment.state, forKey: .comment)
        try container.encodeIfPresent(accountMapping, forKey: .accountMapping)
        try container.encodeIfPresent(tags, forKey: .tags)
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
