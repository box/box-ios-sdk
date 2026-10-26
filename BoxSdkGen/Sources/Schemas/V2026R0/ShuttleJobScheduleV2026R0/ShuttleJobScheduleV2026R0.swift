import Foundation

/// A schedule that starts runs of a shuttle job. A schedule is either
/// time-based or triggered by another job's run. Schedules cannot start a
/// run in `scan` mode.
public class ShuttleJobScheduleV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case jobId = "job_id"
        case state
        case runMode = "run_mode"
        case trigger
        case type
        case description
        case lastAttemptAt = "last_attempt_at"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The unique identifier for the shuttle job schedule.
    public let id: String

    /// The unique identifier of the shuttle job this schedule belongs to.
    public let jobId: String

    /// Whether the schedule is active.
    public let state: ShuttleJobScheduleV2026R0StateField

    /// The kind of run the schedule starts. `scan` is not a valid schedule
    /// run mode.
    public let runMode: ShuttleJobScheduleV2026R0RunModeField

    public let trigger: ShuttleJobScheduleTriggerV2026R0

    /// The value will always be `shuttle_job_schedule`.
    public let type: ShuttleJobScheduleV2026R0TypeField

    /// An optional human-readable description of the schedule.
    @CodableTriState public private(set) var description: String?

    /// When the schedule last attempted to start a run. `null` when the
    /// schedule has never started a run.
    @CodableTriState public private(set) var lastAttemptAt: Date?

    /// Initializer for a ShuttleJobScheduleV2026R0.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the shuttle job schedule.
    ///   - jobId: The unique identifier of the shuttle job this schedule belongs to.
    ///   - state: Whether the schedule is active.
    ///   - runMode: The kind of run the schedule starts. `scan` is not a valid schedule
    ///     run mode.
    ///   - trigger: 
    ///   - type: The value will always be `shuttle_job_schedule`.
    ///   - description: An optional human-readable description of the schedule.
    ///   - lastAttemptAt: When the schedule last attempted to start a run. `null` when the
    ///     schedule has never started a run.
    public init(id: String, jobId: String, state: ShuttleJobScheduleV2026R0StateField, runMode: ShuttleJobScheduleV2026R0RunModeField, trigger: ShuttleJobScheduleTriggerV2026R0, type: ShuttleJobScheduleV2026R0TypeField = ShuttleJobScheduleV2026R0TypeField.shuttleJobSchedule, description: TriStateField<String> = nil, lastAttemptAt: TriStateField<Date> = nil) {
        self.id = id
        self.jobId = jobId
        self.state = state
        self.runMode = runMode
        self.trigger = trigger
        self.type = type
        self._description = CodableTriState(state: description)
        self._lastAttemptAt = CodableTriState(state: lastAttemptAt)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        jobId = try container.decode(String.self, forKey: .jobId)
        state = try container.decode(ShuttleJobScheduleV2026R0StateField.self, forKey: .state)
        runMode = try container.decode(ShuttleJobScheduleV2026R0RunModeField.self, forKey: .runMode)
        trigger = try container.decode(ShuttleJobScheduleTriggerV2026R0.self, forKey: .trigger)
        type = try container.decode(ShuttleJobScheduleV2026R0TypeField.self, forKey: .type)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        lastAttemptAt = try container.decodeDateTimeIfPresent(forKey: .lastAttemptAt)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(jobId, forKey: .jobId)
        try container.encode(state, forKey: .state)
        try container.encode(runMode, forKey: .runMode)
        try container.encode(trigger, forKey: .trigger)
        try container.encode(type, forKey: .type)
        try container.encode(field: _description.state, forKey: .description)
        try container.encodeDateTime(field: _lastAttemptAt.state, forKey: .lastAttemptAt)
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
