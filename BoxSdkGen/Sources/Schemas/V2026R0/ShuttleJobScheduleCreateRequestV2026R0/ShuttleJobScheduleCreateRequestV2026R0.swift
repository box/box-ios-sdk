import Foundation

/// The request body used to create a shuttle job schedule.
public class ShuttleJobScheduleCreateRequestV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case jobId = "job_id"
        case runMode = "run_mode"
        case trigger
        case state
        case description
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The unique identifier of the shuttle job this schedule belongs to.
    public let jobId: String

    /// The kind of run the schedule starts. `scan` is not a valid schedule
    /// run mode.
    public let runMode: ShuttleJobScheduleCreateRequestV2026R0RunModeField

    public let trigger: ShuttleJobScheduleTriggerV2026R0

    /// Whether the schedule is active. When omitted, defaults to `enabled`.
    public let state: ShuttleJobScheduleCreateRequestV2026R0StateField?

    /// An optional human-readable description of the schedule.
    @CodableTriState public private(set) var description: String?

    /// Initializer for a ShuttleJobScheduleCreateRequestV2026R0.
    ///
    /// - Parameters:
    ///   - jobId: The unique identifier of the shuttle job this schedule belongs to.
    ///   - runMode: The kind of run the schedule starts. `scan` is not a valid schedule
    ///     run mode.
    ///   - trigger: 
    ///   - state: Whether the schedule is active. When omitted, defaults to `enabled`.
    ///   - description: An optional human-readable description of the schedule.
    public init(jobId: String, runMode: ShuttleJobScheduleCreateRequestV2026R0RunModeField, trigger: ShuttleJobScheduleTriggerV2026R0, state: ShuttleJobScheduleCreateRequestV2026R0StateField? = nil, description: TriStateField<String> = nil) {
        self.jobId = jobId
        self.runMode = runMode
        self.trigger = trigger
        self.state = state
        self._description = CodableTriState(state: description)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        jobId = try container.decode(String.self, forKey: .jobId)
        runMode = try container.decode(ShuttleJobScheduleCreateRequestV2026R0RunModeField.self, forKey: .runMode)
        trigger = try container.decode(ShuttleJobScheduleTriggerV2026R0.self, forKey: .trigger)
        state = try container.decodeIfPresent(ShuttleJobScheduleCreateRequestV2026R0StateField.self, forKey: .state)
        description = try container.decodeIfPresent(String.self, forKey: .description)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(jobId, forKey: .jobId)
        try container.encode(runMode, forKey: .runMode)
        try container.encode(trigger, forKey: .trigger)
        try container.encodeIfPresent(state, forKey: .state)
        try container.encode(field: _description.state, forKey: .description)
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
