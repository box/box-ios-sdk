import Foundation

public class AddShareLinkToFileRequestBodySharedLinkPermissionsField: Codable {
    private enum CodingKeys: String, CodingKey {
        case canDownload = "can_download"
        case canPreview = "can_preview"
        case canEdit = "can_edit"
    }

    /// If the shared link allows for downloading of files.
    /// This can only be set when `access` is set to
    /// `open` or `company`.
    public let canDownload: Bool?

    /// If the shared link allows for previewing of files.
    /// This value is always `true`. For shared links on folders
    /// this also applies to any items in the folder.
    public let canPreview: Bool?

    /// If the shared link allows for editing of files.
    /// This can only be set when `access` is set to
    /// `open` or `company`.
    /// This value can only be `true` is `can_download` is
    /// also `true`.
    public let canEdit: Bool?

    /// Initializer for a AddShareLinkToFileRequestBodySharedLinkPermissionsField.
    ///
    /// - Parameters:
    ///   - canDownload: If the shared link allows for downloading of files.
    ///     This can only be set when `access` is set to
    ///     `open` or `company`.
    ///   - canPreview: If the shared link allows for previewing of files.
    ///     This value is always `true`. For shared links on folders
    ///     this also applies to any items in the folder.
    ///   - canEdit: If the shared link allows for editing of files.
    ///     This can only be set when `access` is set to
    ///     `open` or `company`.
    ///     This value can only be `true` is `can_download` is
    ///     also `true`.
    public init(canDownload: Bool? = nil, canPreview: Bool? = nil, canEdit: Bool? = nil) {
        self.canDownload = canDownload
        self.canPreview = canPreview
        self.canEdit = canEdit
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        canDownload = try container.decodeIfPresent(Bool.self, forKey: .canDownload)
        canPreview = try container.decodeIfPresent(Bool.self, forKey: .canPreview)
        canEdit = try container.decodeIfPresent(Bool.self, forKey: .canEdit)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(canDownload, forKey: .canDownload)
        try container.encodeIfPresent(canPreview, forKey: .canPreview)
        try container.encodeIfPresent(canEdit, forKey: .canEdit)
    }

}
