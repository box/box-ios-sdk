import Foundation

public class FileSharedLinkPermissionsField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case canDownload = "can_download"
        case canPreview = "can_preview"
        case canEdit = "can_edit"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Defines if the shared link allows for the item to be downloaded. For
    /// shared links on folders, this also applies to any items in the folder.
    /// 
    /// This value can be set to `true` when the effective access level is
    /// set to `open` or `company`, not `collaborators`.
    public let canDownload: Bool

    /// Defines if the shared link allows for the item to be previewed.
    /// 
    /// This value is always `true`. For shared links on folders this also
    /// applies to any items in the folder.
    public let canPreview: Bool

    /// Defines if the shared link allows for the item to be edited.
    /// 
    /// This value can only be `true` if `can_download` is also `true` and if
    /// the item has a type of `file`.
    public let canEdit: Bool

    /// Initializer for a FileSharedLinkPermissionsField.
    ///
    /// - Parameters:
    ///   - canDownload: Defines if the shared link allows for the item to be downloaded. For
    ///     shared links on folders, this also applies to any items in the folder.
    ///     
    ///     This value can be set to `true` when the effective access level is
    ///     set to `open` or `company`, not `collaborators`.
    ///   - canPreview: Defines if the shared link allows for the item to be previewed.
    ///     
    ///     This value is always `true`. For shared links on folders this also
    ///     applies to any items in the folder.
    ///   - canEdit: Defines if the shared link allows for the item to be edited.
    ///     
    ///     This value can only be `true` if `can_download` is also `true` and if
    ///     the item has a type of `file`.
    public init(canDownload: Bool, canPreview: Bool, canEdit: Bool) {
        self.canDownload = canDownload
        self.canPreview = canPreview
        self.canEdit = canEdit
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        canDownload = try container.decode(Bool.self, forKey: .canDownload)
        canPreview = try container.decode(Bool.self, forKey: .canPreview)
        canEdit = try container.decode(Bool.self, forKey: .canEdit)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(canDownload, forKey: .canDownload)
        try container.encode(canPreview, forKey: .canPreview)
        try container.encode(canEdit, forKey: .canEdit)
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
