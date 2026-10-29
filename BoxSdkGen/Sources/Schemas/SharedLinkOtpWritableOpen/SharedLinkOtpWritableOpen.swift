import Foundation

/// Any anonymous recipient can request a one-time-passcode to any email
/// address and access the shared link after verifying it. Collaborators
/// and registered Box users access the link without being prompted.
public class SharedLinkOtpWritableOpen: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case mode
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Set to `open` to allow any anonymous recipient to request a
    /// one-time-passcode to any email address.
    public let mode: SharedLinkOtpWritableOpenModeField

    /// Initializer for a SharedLinkOtpWritableOpen.
    ///
    /// - Parameters:
    ///   - mode: Set to `open` to allow any anonymous recipient to request a
    ///     one-time-passcode to any email address.
    public init(mode: SharedLinkOtpWritableOpenModeField = SharedLinkOtpWritableOpenModeField.open) {
        self.mode = mode
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mode = try container.decode(SharedLinkOtpWritableOpenModeField.self, forKey: .mode)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mode, forKey: .mode)
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
