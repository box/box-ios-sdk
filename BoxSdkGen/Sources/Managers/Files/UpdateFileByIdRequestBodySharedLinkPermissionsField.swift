import Foundation

public class UpdateFileByIdRequestBodySharedLinkPermissionsField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case canDownload = "can_download"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// If the shared link allows for downloading of files.
    /// This can only be set when `access` is set to
    /// `open` or `company`.
    public let canDownload: Bool?

    /// Initializer for a UpdateFileByIdRequestBodySharedLinkPermissionsField.
    ///
    /// - Parameters:
    ///   - canDownload: If the shared link allows for downloading of files.
    ///     This can only be set when `access` is set to
    ///     `open` or `company`.
    public init(canDownload: Bool? = nil) {
        self.canDownload = canDownload
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        canDownload = try container.decodeIfPresent(Bool.self, forKey: .canDownload)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(canDownload, forKey: .canDownload)
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
