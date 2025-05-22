import Foundation

public class UpdateFolderByIdRequestBodySharedLinkPermissionsField: Codable {
    private enum CodingKeys: String, CodingKey {
        case canDownload = "can_download"
    }

    /// If the shared link allows for downloading of files.
    /// This can only be set when `access` is set to
    /// `open` or `company`.
    public let canDownload: Bool?

    /// Initializer for a UpdateFolderByIdRequestBodySharedLinkPermissionsField.
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

}
