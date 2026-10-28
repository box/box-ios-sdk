import Foundation

/// One-time-passcode (OTP) enforcement is turned off. The shared link is
/// accessible without any one-time-passcode verification.
public class SharedLinkOtpWritableNone: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case mode
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Set to `none` to disable OTP enforcement for the shared link.
    public let mode: SharedLinkOtpWritableNoneModeField

    /// Initializer for a SharedLinkOtpWritableNone.
    ///
    /// - Parameters:
    ///   - mode: Set to `none` to disable OTP enforcement for the shared link.
    public init(mode: SharedLinkOtpWritableNoneModeField = SharedLinkOtpWritableNoneModeField.none) {
        self.mode = mode
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mode = try container.decode(SharedLinkOtpWritableNoneModeField.self, forKey: .mode)
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
