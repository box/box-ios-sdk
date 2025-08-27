import Foundation

public class UpdateFileByIdRequestBodyPermissionsField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case canDownload = "can_download"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Defines who is allowed to download this file. The possible
    /// values are either `open` for everyone or `company` for
    /// the other members of the user's enterprise.
    /// 
    /// This setting overrides the download permissions that are
    /// normally part of the `role` of a collaboration. When set to
    /// `company`, this essentially removes the download option for
    /// external users with `viewer` or `editor` a roles.
    public let canDownload: UpdateFileByIdRequestBodyPermissionsCanDownloadField?

    /// Initializer for a UpdateFileByIdRequestBodyPermissionsField.
    ///
    /// - Parameters:
    ///   - canDownload: Defines who is allowed to download this file. The possible
    ///     values are either `open` for everyone or `company` for
    ///     the other members of the user's enterprise.
    ///     
    ///     This setting overrides the download permissions that are
    ///     normally part of the `role` of a collaboration. When set to
    ///     `company`, this essentially removes the download option for
    ///     external users with `viewer` or `editor` a roles.
    public init(canDownload: UpdateFileByIdRequestBodyPermissionsCanDownloadField? = nil) {
        self.canDownload = canDownload
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        canDownload = try container.decodeIfPresent(UpdateFileByIdRequestBodyPermissionsCanDownloadField.self, forKey: .canDownload)
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
