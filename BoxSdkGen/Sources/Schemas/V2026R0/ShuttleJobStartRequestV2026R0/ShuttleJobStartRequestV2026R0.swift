import Foundation

/// The request body used to start a shuttle job.
public class ShuttleJobStartRequestV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case mode
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The run mode. Defaults to simulation when omitted.
    public let mode: ShuttleJobStartRequestV2026R0ModeField?

    /// Initializer for a ShuttleJobStartRequestV2026R0.
    ///
    /// - Parameters:
    ///   - mode: The run mode. Defaults to simulation when omitted.
    public init(mode: ShuttleJobStartRequestV2026R0ModeField? = nil) {
        self.mode = mode
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mode = try container.decodeIfPresent(ShuttleJobStartRequestV2026R0ModeField.self, forKey: .mode)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(mode, forKey: .mode)
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
