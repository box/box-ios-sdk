import Foundation

/// The request body used to update an existing shuttle job schedule. Only
/// the fields supplied in the request body are changed.
public class ShuttleJobScheduleUpdateRequestV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case state
        case runMode = "run_mode"
        case description
        case trigger
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Whether the schedule is active.
    public let state: ShuttleJobScheduleUpdateRequestV2026R0StateField?

    /// The kind of run the schedule starts. `scan` is not a valid schedule
    /// run mode.
    public let runMode: ShuttleJobScheduleUpdateRequestV2026R0RunModeField?

    /// An optional human-readable description of the schedule.
    @CodableTriState public private(set) var description: String?

    public let trigger: ShuttleJobScheduleTriggerV2026R0?

    /// Initializer for a ShuttleJobScheduleUpdateRequestV2026R0.
    ///
    /// - Parameters:
    ///   - state: Whether the schedule is active.
    ///   - runMode: The kind of run the schedule starts. `scan` is not a valid schedule
    ///     run mode.
    ///   - description: An optional human-readable description of the schedule.
    ///   - trigger: 
    public init(state: ShuttleJobScheduleUpdateRequestV2026R0StateField? = nil, runMode: ShuttleJobScheduleUpdateRequestV2026R0RunModeField? = nil, description: TriStateField<String> = nil, trigger: ShuttleJobScheduleTriggerV2026R0? = nil) {
        self.state = state
        self.runMode = runMode
        self._description = CodableTriState(state: description)
        self.trigger = trigger
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        state = try container.decodeIfPresent(ShuttleJobScheduleUpdateRequestV2026R0StateField.self, forKey: .state)
        runMode = try container.decodeIfPresent(ShuttleJobScheduleUpdateRequestV2026R0RunModeField.self, forKey: .runMode)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        trigger = try container.decodeIfPresent(ShuttleJobScheduleTriggerV2026R0.self, forKey: .trigger)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(state, forKey: .state)
        try container.encodeIfPresent(runMode, forKey: .runMode)
        try container.encode(field: _description.state, forKey: .description)
        try container.encodeIfPresent(trigger, forKey: .trigger)
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
