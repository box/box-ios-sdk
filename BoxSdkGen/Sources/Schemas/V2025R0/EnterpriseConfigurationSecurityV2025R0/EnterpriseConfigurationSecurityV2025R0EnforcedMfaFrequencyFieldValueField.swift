import Foundation

public class EnterpriseConfigurationSecurityV2025R0EnforcedMfaFrequencyFieldValueField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case days
        case hours
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Number of days before the user is required to authenticate again.
    @CodableTriState public private(set) var days: Int64?

    /// Number of hours before the user is required to authenticate again.
    @CodableTriState public private(set) var hours: Int64?

    /// Initializer for a EnterpriseConfigurationSecurityV2025R0EnforcedMfaFrequencyFieldValueField.
    ///
    /// - Parameters:
    ///   - days: Number of days before the user is required to authenticate again.
    ///   - hours: Number of hours before the user is required to authenticate again.
    public init(days: TriStateField<Int64> = nil, hours: TriStateField<Int64> = nil) {
        self._days = CodableTriState(state: days)
        self._hours = CodableTriState(state: hours)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        days = try container.decodeIfPresent(Int64.self, forKey: .days)
        hours = try container.decodeIfPresent(Int64.self, forKey: .hours)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(field: _days.state, forKey: .days)
        try container.encode(field: _hours.state, forKey: .hours)
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
