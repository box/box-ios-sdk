import Foundation

public class UpdateFileByIdRequestBodyPermissionsField: Codable {
    private enum CodingKeys: String, CodingKey {
        case canDownload = "can_download"
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

}
