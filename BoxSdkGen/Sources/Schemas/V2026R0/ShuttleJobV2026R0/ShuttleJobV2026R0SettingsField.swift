import Foundation

public class ShuttleJobV2026R0SettingsField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case bandwidthLimitBytesPerSec = "bandwidth_limit_bytes_per_sec"
        case areDeletionsMirrored = "are_deletions_mirrored"
        case areFileVersionsSynced = "are_file_versions_synced"
        case maxFileVersions = "max_file_versions"
        case isOverwriteEnabled = "is_overwrite_enabled"
        case areCompletedMappingsSkippedOnRerun = "are_completed_mappings_skipped_on_rerun"
        case isContentScanningEnabled = "is_content_scanning_enabled"
        case includeSharedSourceFolders = "include_shared_source_folders"
        case includeSharedDestinationFolders = "include_shared_destination_folders"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The maximum transfer bandwidth in bytes per second. `null` when
    /// unlimited.
    @CodableTriState public private(set) var bandwidthLimitBytesPerSec: Int64?

    /// Whether deletions in the source system are mirrored in Box.
    public let areDeletionsMirrored: Bool?

    /// Whether prior file versions are synced during the migration.
    public let areFileVersionsSynced: Bool?

    /// The maximum number of file versions to sync. `null` when unlimited.
    @CodableTriState public private(set) var maxFileVersions: Int?

    /// Whether existing files in Box are overwritten.
    public let isOverwriteEnabled: Bool?

    /// Whether mappings that already completed successfully are skipped when
    /// the job is rerun.
    public let areCompletedMappingsSkippedOnRerun: Bool?

    /// Whether migrated content is scanned during the migration. Applies
    /// only when the source system supports content scanning; ignored
    /// otherwise.
    public let isContentScanningEnabled: Bool?

    /// Whether shared folders on the source are included in the migration.
    /// Applies only when the source system supports shared folders; ignored
    /// otherwise.
    public let includeSharedSourceFolders: Bool?

    /// Whether shared folders on the destination are included in the
    /// migration. Applies only when the destination system supports shared
    /// folders; ignored otherwise.
    public let includeSharedDestinationFolders: Bool?

    /// Initializer for a ShuttleJobV2026R0SettingsField.
    ///
    /// - Parameters:
    ///   - bandwidthLimitBytesPerSec: The maximum transfer bandwidth in bytes per second. `null` when
    ///     unlimited.
    ///   - areDeletionsMirrored: Whether deletions in the source system are mirrored in Box.
    ///   - areFileVersionsSynced: Whether prior file versions are synced during the migration.
    ///   - maxFileVersions: The maximum number of file versions to sync. `null` when unlimited.
    ///   - isOverwriteEnabled: Whether existing files in Box are overwritten.
    ///   - areCompletedMappingsSkippedOnRerun: Whether mappings that already completed successfully are skipped when
    ///     the job is rerun.
    ///   - isContentScanningEnabled: Whether migrated content is scanned during the migration. Applies
    ///     only when the source system supports content scanning; ignored
    ///     otherwise.
    ///   - includeSharedSourceFolders: Whether shared folders on the source are included in the migration.
    ///     Applies only when the source system supports shared folders; ignored
    ///     otherwise.
    ///   - includeSharedDestinationFolders: Whether shared folders on the destination are included in the
    ///     migration. Applies only when the destination system supports shared
    ///     folders; ignored otherwise.
    public init(bandwidthLimitBytesPerSec: TriStateField<Int64> = nil, areDeletionsMirrored: Bool? = nil, areFileVersionsSynced: Bool? = nil, maxFileVersions: TriStateField<Int> = nil, isOverwriteEnabled: Bool? = nil, areCompletedMappingsSkippedOnRerun: Bool? = nil, isContentScanningEnabled: Bool? = nil, includeSharedSourceFolders: Bool? = nil, includeSharedDestinationFolders: Bool? = nil) {
        self._bandwidthLimitBytesPerSec = CodableTriState(state: bandwidthLimitBytesPerSec)
        self.areDeletionsMirrored = areDeletionsMirrored
        self.areFileVersionsSynced = areFileVersionsSynced
        self._maxFileVersions = CodableTriState(state: maxFileVersions)
        self.isOverwriteEnabled = isOverwriteEnabled
        self.areCompletedMappingsSkippedOnRerun = areCompletedMappingsSkippedOnRerun
        self.isContentScanningEnabled = isContentScanningEnabled
        self.includeSharedSourceFolders = includeSharedSourceFolders
        self.includeSharedDestinationFolders = includeSharedDestinationFolders
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        bandwidthLimitBytesPerSec = try container.decodeIfPresent(Int64.self, forKey: .bandwidthLimitBytesPerSec)
        areDeletionsMirrored = try container.decodeIfPresent(Bool.self, forKey: .areDeletionsMirrored)
        areFileVersionsSynced = try container.decodeIfPresent(Bool.self, forKey: .areFileVersionsSynced)
        maxFileVersions = try container.decodeIfPresent(Int.self, forKey: .maxFileVersions)
        isOverwriteEnabled = try container.decodeIfPresent(Bool.self, forKey: .isOverwriteEnabled)
        areCompletedMappingsSkippedOnRerun = try container.decodeIfPresent(Bool.self, forKey: .areCompletedMappingsSkippedOnRerun)
        isContentScanningEnabled = try container.decodeIfPresent(Bool.self, forKey: .isContentScanningEnabled)
        includeSharedSourceFolders = try container.decodeIfPresent(Bool.self, forKey: .includeSharedSourceFolders)
        includeSharedDestinationFolders = try container.decodeIfPresent(Bool.self, forKey: .includeSharedDestinationFolders)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(field: _bandwidthLimitBytesPerSec.state, forKey: .bandwidthLimitBytesPerSec)
        try container.encodeIfPresent(areDeletionsMirrored, forKey: .areDeletionsMirrored)
        try container.encodeIfPresent(areFileVersionsSynced, forKey: .areFileVersionsSynced)
        try container.encode(field: _maxFileVersions.state, forKey: .maxFileVersions)
        try container.encodeIfPresent(isOverwriteEnabled, forKey: .isOverwriteEnabled)
        try container.encodeIfPresent(areCompletedMappingsSkippedOnRerun, forKey: .areCompletedMappingsSkippedOnRerun)
        try container.encodeIfPresent(isContentScanningEnabled, forKey: .isContentScanningEnabled)
        try container.encodeIfPresent(includeSharedSourceFolders, forKey: .includeSharedSourceFolders)
        try container.encodeIfPresent(includeSharedDestinationFolders, forKey: .includeSharedDestinationFolders)
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
