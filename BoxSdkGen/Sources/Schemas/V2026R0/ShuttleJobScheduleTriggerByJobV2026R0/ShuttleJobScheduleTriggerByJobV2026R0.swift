import Foundation

/// A job-based trigger that starts this schedule after another shuttle
/// job's run meets a condition.
public class ShuttleJobScheduleTriggerByJobV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case triggeredByJobId = "triggered_by_job_id"
        case lastRunCondition = "last_run_condition"
        case type
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The unique identifier of the shuttle job whose run starts this
    /// schedule.
    public let triggeredByJobId: String

    /// When this schedule should start a run relative to the last run of
    /// the triggering job.
    public let lastRunCondition: ShuttleJobScheduleTriggerByJobV2026R0LastRunConditionField

    /// The value will always be `by_job`.
    public let type: ShuttleJobScheduleTriggerByJobV2026R0TypeField

    /// Initializer for a ShuttleJobScheduleTriggerByJobV2026R0.
    ///
    /// - Parameters:
    ///   - triggeredByJobId: The unique identifier of the shuttle job whose run starts this
    ///     schedule.
    ///   - lastRunCondition: When this schedule should start a run relative to the last run of
    ///     the triggering job.
    ///   - type: The value will always be `by_job`.
    public init(triggeredByJobId: String, lastRunCondition: ShuttleJobScheduleTriggerByJobV2026R0LastRunConditionField, type: ShuttleJobScheduleTriggerByJobV2026R0TypeField = ShuttleJobScheduleTriggerByJobV2026R0TypeField.byJob) {
        self.triggeredByJobId = triggeredByJobId
        self.lastRunCondition = lastRunCondition
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        triggeredByJobId = try container.decode(String.self, forKey: .triggeredByJobId)
        lastRunCondition = try container.decode(ShuttleJobScheduleTriggerByJobV2026R0LastRunConditionField.self, forKey: .lastRunCondition)
        type = try container.decode(ShuttleJobScheduleTriggerByJobV2026R0TypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(triggeredByJobId, forKey: .triggeredByJobId)
        try container.encode(lastRunCondition, forKey: .lastRunCondition)
        try container.encode(type, forKey: .type)
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
