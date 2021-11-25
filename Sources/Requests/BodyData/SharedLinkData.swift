import Foundation

/// Defines shared link data for updating file information.
/// Shared links provide direct, read-only access to files or folder on Box using a URL
public struct SharedLinkData: Encodable {
    /// The access level for the shared link. Can be open ("People with the link"),
    /// company ("People in your company"), or collaborators ("People in this folder").
    /// When creating a shared link, if you omit this field then the access level will be set
    /// to the default access level specified by the enterprise admin.
    public let access: SharedLinkAccess?
    /// The password required to access the shared link.
    public let password: NullableParameter<String>?
    /// The date-time that this link will become disabled.
    public let unsharedAt: NullableParameter<Date>?
    /// The custom vanity name to use in the shared link URL.
    /// It should be between 12 and 30 characters. This field can contains only letters, numbers, and hyphens.
    /// Custom URLs should not be used when sharing sensitive content as vanity URLs are a lot easier to guess than regular shared links.
    public let vanityName: NullableParameter<String>?
    /// Whether the shared link allows downloads and previews.
    public let permissions: [String: Bool]?

    /// Initializer.
    ///
    /// - Parameters:
    ///   - access: The access level for the shared link
    ///   - password: The password required to access the shared link. Set to null to remove the password.
    ///   - unsharedAt: The date-time that this link will become disabled. This field can only be set by users with paid accounts.
    ///   - vanityName: The custom vanity name to use in the shared link URL.
    ///     It should be between 12 and 30 characters. This field can contains only letters, numbers, and hyphens.
    ///   - canDownload: Permission specifying whether user can download from the shared link.
    public init(
        access: SharedLinkAccess? = nil,
        password: NullableParameter<String>? = nil,
        unsharedAt: NullableParameter<Date>? = nil,
        vanityName: NullableParameter<String>? = nil,
        canDownload: Bool? = nil
    ) {
        self.access = access
        self.password = password
        self.unsharedAt = unsharedAt
        self.vanityName = vanityName

        if let canDownload = canDownload {
            permissions = ["can_download": canDownload]
        }
        else {
            permissions = nil
        }
    }
}
