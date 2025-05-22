import Foundation

public class WebLinkSharedLinkField: Codable {
    private enum CodingKeys: String, CodingKey {
        case url
        case effectiveAccess = "effective_access"
        case effectivePermission = "effective_permission"
        case isPasswordEnabled = "is_password_enabled"
        case downloadCount = "download_count"
        case previewCount = "preview_count"
        case downloadUrl = "download_url"
        case vanityUrl = "vanity_url"
        case vanityName = "vanity_name"
        case access
        case unsharedAt = "unshared_at"
        case permissions
    }

    /// The URL that can be used to access the item on Box.
    /// 
    /// This URL will display the item in Box's preview UI where the file
    /// can be downloaded if allowed.
    /// 
    /// This URL will continue to work even when a custom `vanity_url`
    /// has been set for this shared link.
    public let url: String

    /// The effective access level for the shared link. This can be a more
    /// restrictive access level than the value in the `access` field when the
    /// enterprise settings restrict the allowed access levels.
    public let effectiveAccess: WebLinkSharedLinkEffectiveAccessField

    /// The effective permissions for this shared link.
    /// These result in the more restrictive combination of
    /// the share link permissions and the item permissions set
    /// by the administrator, the owner, and any ancestor item
    /// such as a folder.
    public let effectivePermission: WebLinkSharedLinkEffectivePermissionField

    /// Defines if the shared link requires a password to access the item.
    public let isPasswordEnabled: Bool

    /// The number of times this item has been downloaded.
    public let downloadCount: Int64

    /// The number of times this item has been previewed.
    public let previewCount: Int64

    /// A URL that can be used to download the file. This URL can be used in
    /// a browser to download the file. This URL includes the file
    /// extension so that the file will be saved with the right file type.
    /// 
    /// This property will be `null` for folders.
    @CodableTriState public private(set) var downloadUrl: String?

    /// The "Custom URL" that can also be used to preview the item on Box.  Custom
    /// URLs can only be created or modified in the Box Web application.
    @CodableTriState public private(set) var vanityUrl: String?

    /// The custom name of a shared link, as used in the `vanity_url` field.
    @CodableTriState public private(set) var vanityName: String?

    /// The access level for this shared link.
    /// 
    /// * `open` - provides access to this item to anyone with this link
    /// * `company` - only provides access to this item to people the same company
    /// * `collaborators` - only provides access to this item to people who are
    ///    collaborators on this item
    /// 
    /// If this field is omitted when creating the shared link, the access level
    /// will be set to the default access level specified by the enterprise admin.
    public let access: WebLinkSharedLinkAccessField?

    /// The date and time when this link will be unshared. This field can only be
    /// set by users with paid accounts.
    @CodableTriState public private(set) var unsharedAt: Date?

    /// Defines if this link allows a user to preview, edit, and download an item.
    /// These permissions refer to the shared link only and
    /// do not supersede permissions applied to the item itself.
    public let permissions: WebLinkSharedLinkPermissionsField?

    /// Initializer for a WebLinkSharedLinkField.
    ///
    /// - Parameters:
    ///   - url: The URL that can be used to access the item on Box.
    ///     
    ///     This URL will display the item in Box's preview UI where the file
    ///     can be downloaded if allowed.
    ///     
    ///     This URL will continue to work even when a custom `vanity_url`
    ///     has been set for this shared link.
    ///   - effectiveAccess: The effective access level for the shared link. This can be a more
    ///     restrictive access level than the value in the `access` field when the
    ///     enterprise settings restrict the allowed access levels.
    ///   - effectivePermission: The effective permissions for this shared link.
    ///     These result in the more restrictive combination of
    ///     the share link permissions and the item permissions set
    ///     by the administrator, the owner, and any ancestor item
    ///     such as a folder.
    ///   - isPasswordEnabled: Defines if the shared link requires a password to access the item.
    ///   - downloadCount: The number of times this item has been downloaded.
    ///   - previewCount: The number of times this item has been previewed.
    ///   - downloadUrl: A URL that can be used to download the file. This URL can be used in
    ///     a browser to download the file. This URL includes the file
    ///     extension so that the file will be saved with the right file type.
    ///     
    ///     This property will be `null` for folders.
    ///   - vanityUrl: The "Custom URL" that can also be used to preview the item on Box.  Custom
    ///     URLs can only be created or modified in the Box Web application.
    ///   - vanityName: The custom name of a shared link, as used in the `vanity_url` field.
    ///   - access: The access level for this shared link.
    ///     
    ///     * `open` - provides access to this item to anyone with this link
    ///     * `company` - only provides access to this item to people the same company
    ///     * `collaborators` - only provides access to this item to people who are
    ///        collaborators on this item
    ///     
    ///     If this field is omitted when creating the shared link, the access level
    ///     will be set to the default access level specified by the enterprise admin.
    ///   - unsharedAt: The date and time when this link will be unshared. This field can only be
    ///     set by users with paid accounts.
    ///   - permissions: Defines if this link allows a user to preview, edit, and download an item.
    ///     These permissions refer to the shared link only and
    ///     do not supersede permissions applied to the item itself.
    public init(url: String, effectiveAccess: WebLinkSharedLinkEffectiveAccessField, effectivePermission: WebLinkSharedLinkEffectivePermissionField, isPasswordEnabled: Bool, downloadCount: Int64, previewCount: Int64, downloadUrl: TriStateField<String> = nil, vanityUrl: TriStateField<String> = nil, vanityName: TriStateField<String> = nil, access: WebLinkSharedLinkAccessField? = nil, unsharedAt: TriStateField<Date> = nil, permissions: WebLinkSharedLinkPermissionsField? = nil) {
        self.url = url
        self.effectiveAccess = effectiveAccess
        self.effectivePermission = effectivePermission
        self.isPasswordEnabled = isPasswordEnabled
        self.downloadCount = downloadCount
        self.previewCount = previewCount
        self._downloadUrl = CodableTriState(state: downloadUrl)
        self._vanityUrl = CodableTriState(state: vanityUrl)
        self._vanityName = CodableTriState(state: vanityName)
        self.access = access
        self._unsharedAt = CodableTriState(state: unsharedAt)
        self.permissions = permissions
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decode(String.self, forKey: .url)
        effectiveAccess = try container.decode(WebLinkSharedLinkEffectiveAccessField.self, forKey: .effectiveAccess)
        effectivePermission = try container.decode(WebLinkSharedLinkEffectivePermissionField.self, forKey: .effectivePermission)
        isPasswordEnabled = try container.decode(Bool.self, forKey: .isPasswordEnabled)
        downloadCount = try container.decode(Int64.self, forKey: .downloadCount)
        previewCount = try container.decode(Int64.self, forKey: .previewCount)
        downloadUrl = try container.decodeIfPresent(String.self, forKey: .downloadUrl)
        vanityUrl = try container.decodeIfPresent(String.self, forKey: .vanityUrl)
        vanityName = try container.decodeIfPresent(String.self, forKey: .vanityName)
        access = try container.decodeIfPresent(WebLinkSharedLinkAccessField.self, forKey: .access)
        unsharedAt = try container.decodeDateTimeIfPresent(forKey: .unsharedAt)
        permissions = try container.decodeIfPresent(WebLinkSharedLinkPermissionsField.self, forKey: .permissions)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(url, forKey: .url)
        try container.encode(effectiveAccess, forKey: .effectiveAccess)
        try container.encode(effectivePermission, forKey: .effectivePermission)
        try container.encode(isPasswordEnabled, forKey: .isPasswordEnabled)
        try container.encode(downloadCount, forKey: .downloadCount)
        try container.encode(previewCount, forKey: .previewCount)
        try container.encode(field: _downloadUrl.state, forKey: .downloadUrl)
        try container.encode(field: _vanityUrl.state, forKey: .vanityUrl)
        try container.encode(field: _vanityName.state, forKey: .vanityName)
        try container.encodeIfPresent(access, forKey: .access)
        try container.encodeDateTime(field: _unsharedAt.state, forKey: .unsharedAt)
        try container.encodeIfPresent(permissions, forKey: .permissions)
    }

}
