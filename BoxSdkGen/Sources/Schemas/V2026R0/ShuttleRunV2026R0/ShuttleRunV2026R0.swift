import Foundation

/// A historical instance of a shuttle job run. A run is created each time
/// a job is started. Run IDs have the form `{job_id}:{run_number}`.
public class ShuttleRunV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case jobId = "job_id"
        case runMode = "run_mode"
        case state
        case type
        case startedAt = "started_at"
        case endedAt = "ended_at"
        case durationSeconds = "duration_seconds"
        case stats
        case createdBy = "created_by"
        case availableReportSections = "available_report_sections"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The unique identifier for the shuttle run, in the form
    /// `{job_id}:{run_number}`.
    public let id: String

    /// The unique identifier of the shuttle job this run belongs to.
    public let jobId: String

    /// The mode the run was started in. This is an open string whose set of
    /// values is expected to grow; the currently documented values include
    /// `transfer`, `simulation`, `analysis`, `scan`, and `unknown`. Clients
    /// should treat any value they do not recognize as `unknown`.
    public let runMode: String

    /// The current state of the shuttle run. This is an open string whose set
    /// of values is expected to grow; the currently documented values include
    /// `running`, `stopping`, `completed`, `completed_with_errors`, `stopped`,
    /// `failed`, `timed_out`, and `unknown`. Clients should treat any value
    /// they do not recognize as `unknown`.
    public let state: String

    /// The value will always be `shuttle_run`.
    public let type: ShuttleRunV2026R0TypeField

    /// When the run started.
    public let startedAt: Date?

    /// When the run ended. `null` while the run is still in progress.
    @CodableTriState public private(set) var endedAt: Date?

    /// Total duration of the run in seconds. `null` while the run is still in
    /// progress.
    @CodableTriState public private(set) var durationSeconds: Int64?

    /// Transfer statistics collected during the run.
    public let stats: ShuttleRunV2026R0StatsField?

    /// The user who started the run. `null` for schedule- or system-initiated
    /// runs.
    public let createdBy: UserBaseV2026R0?

    /// Report sections that can be requested for this run. This is an open
    /// list whose set of values is expected to grow; the currently documented
    /// values include `files_and_folders`, `event_log`, `transfer_overview`,
    /// `source_users`, `target_users`, `source_collaborators`,
    /// `target_collaborators`, `source_collaborations`, and
    /// `target_collaborations`.
    public let availableReportSections: [String]?

    /// Initializer for a ShuttleRunV2026R0.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the shuttle run, in the form
    ///     `{job_id}:{run_number}`.
    ///   - jobId: The unique identifier of the shuttle job this run belongs to.
    ///   - runMode: The mode the run was started in. This is an open string whose set of
    ///     values is expected to grow; the currently documented values include
    ///     `transfer`, `simulation`, `analysis`, `scan`, and `unknown`. Clients
    ///     should treat any value they do not recognize as `unknown`.
    ///   - state: The current state of the shuttle run. This is an open string whose set
    ///     of values is expected to grow; the currently documented values include
    ///     `running`, `stopping`, `completed`, `completed_with_errors`, `stopped`,
    ///     `failed`, `timed_out`, and `unknown`. Clients should treat any value
    ///     they do not recognize as `unknown`.
    ///   - type: The value will always be `shuttle_run`.
    ///   - startedAt: When the run started.
    ///   - endedAt: When the run ended. `null` while the run is still in progress.
    ///   - durationSeconds: Total duration of the run in seconds. `null` while the run is still in
    ///     progress.
    ///   - stats: Transfer statistics collected during the run.
    ///   - createdBy: The user who started the run. `null` for schedule- or system-initiated
    ///     runs.
    ///   - availableReportSections: Report sections that can be requested for this run. This is an open
    ///     list whose set of values is expected to grow; the currently documented
    ///     values include `files_and_folders`, `event_log`, `transfer_overview`,
    ///     `source_users`, `target_users`, `source_collaborators`,
    ///     `target_collaborators`, `source_collaborations`, and
    ///     `target_collaborations`.
    public init(id: String, jobId: String, runMode: String, state: String, type: ShuttleRunV2026R0TypeField = ShuttleRunV2026R0TypeField.shuttleRun, startedAt: Date? = nil, endedAt: TriStateField<Date> = nil, durationSeconds: TriStateField<Int64> = nil, stats: ShuttleRunV2026R0StatsField? = nil, createdBy: UserBaseV2026R0? = nil, availableReportSections: [String]? = nil) {
        self.id = id
        self.jobId = jobId
        self.runMode = runMode
        self.state = state
        self.type = type
        self.startedAt = startedAt
        self._endedAt = CodableTriState(state: endedAt)
        self._durationSeconds = CodableTriState(state: durationSeconds)
        self.stats = stats
        self.createdBy = createdBy
        self.availableReportSections = availableReportSections
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        jobId = try container.decode(String.self, forKey: .jobId)
        runMode = try container.decode(String.self, forKey: .runMode)
        state = try container.decode(String.self, forKey: .state)
        type = try container.decode(ShuttleRunV2026R0TypeField.self, forKey: .type)
        startedAt = try container.decodeDateTimeIfPresent(forKey: .startedAt)
        endedAt = try container.decodeDateTimeIfPresent(forKey: .endedAt)
        durationSeconds = try container.decodeIfPresent(Int64.self, forKey: .durationSeconds)
        stats = try container.decodeIfPresent(ShuttleRunV2026R0StatsField.self, forKey: .stats)
        createdBy = try container.decodeIfPresent(UserBaseV2026R0.self, forKey: .createdBy)
        availableReportSections = try container.decodeIfPresent([String].self, forKey: .availableReportSections)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(jobId, forKey: .jobId)
        try container.encode(runMode, forKey: .runMode)
        try container.encode(state, forKey: .state)
        try container.encode(type, forKey: .type)
        try container.encodeDateTimeIfPresent(field: startedAt, forKey: .startedAt)
        try container.encodeDateTime(field: _endedAt.state, forKey: .endedAt)
        try container.encode(field: _durationSeconds.state, forKey: .durationSeconds)
        try container.encodeIfPresent(stats, forKey: .stats)
        try container.encodeIfPresent(createdBy, forKey: .createdBy)
        try container.encodeIfPresent(availableReportSections, forKey: .availableReportSections)
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
