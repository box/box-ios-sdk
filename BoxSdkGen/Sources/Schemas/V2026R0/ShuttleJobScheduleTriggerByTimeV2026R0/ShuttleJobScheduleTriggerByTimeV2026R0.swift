import Foundation

/// A time-based trigger that starts the schedule at a wall-clock time and
/// optionally repeats.
public class ShuttleJobScheduleTriggerByTimeV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case startAt = "start_at"
        case timeZone = "time_zone"
        case repeat
        case type
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The local wall-clock time when the schedule should first start a
    /// run, without an offset or `Z` suffix. Combined with `time_zone` to
    /// determine the instant, including DST.
    public let startAt: String

    /// The IANA time zone that gives `start_at` its calendar meaning (for
    /// example `America/Los_Angeles`). Recurrence and DST transitions are
    /// evaluated in this zone.
    public let timeZone: String

    /// How often the schedule repeats after `start_at`.
    public let repeat: ShuttleJobScheduleTriggerByTimeV2026R0RepeatField

    /// The value will always be `by_time`.
    public let type: ShuttleJobScheduleTriggerByTimeV2026R0TypeField

    /// Initializer for a ShuttleJobScheduleTriggerByTimeV2026R0.
    ///
    /// - Parameters:
    ///   - startAt: The local wall-clock time when the schedule should first start a
    ///     run, without an offset or `Z` suffix. Combined with `time_zone` to
    ///     determine the instant, including DST.
    ///   - timeZone: The IANA time zone that gives `start_at` its calendar meaning (for
    ///     example `America/Los_Angeles`). Recurrence and DST transitions are
    ///     evaluated in this zone.
    ///   - repeat: How often the schedule repeats after `start_at`.
    ///   - type: The value will always be `by_time`.
    public init(startAt: String, timeZone: String, repeat: ShuttleJobScheduleTriggerByTimeV2026R0RepeatField, type: ShuttleJobScheduleTriggerByTimeV2026R0TypeField = ShuttleJobScheduleTriggerByTimeV2026R0TypeField.byTime) {
        self.startAt = startAt
        self.timeZone = timeZone
        self.repeat = repeat
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        startAt = try container.decode(String.self, forKey: .startAt)
        timeZone = try container.decode(String.self, forKey: .timeZone)
        repeat = try container.decode(ShuttleJobScheduleTriggerByTimeV2026R0RepeatField.self, forKey: .repeat)
        type = try container.decode(ShuttleJobScheduleTriggerByTimeV2026R0TypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(startAt, forKey: .startAt)
        try container.encode(timeZone, forKey: .timeZone)
        try container.encode(repeat, forKey: .repeat)
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
