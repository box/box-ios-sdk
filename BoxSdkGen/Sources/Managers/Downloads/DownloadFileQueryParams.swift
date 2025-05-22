import Foundation

public class DownloadFileQueryParams {
    /// The file version to download
    public let version: String?

    /// An optional access token that can be used to pre-authenticate this request, which means that a download link can be shared with a browser or a third party service without them needing to know how to handle the authentication.
    /// When using this parameter, please make sure that the access token is sufficiently scoped down to only allow read access to that file and no other files or folders.
    public let accessToken: String?

    /// Initializer for a DownloadFileQueryParams.
    ///
    /// - Parameters:
    ///   - version: The file version to download
    ///   - accessToken: An optional access token that can be used to pre-authenticate this request, which means that a download link can be shared with a browser or a third party service without them needing to know how to handle the authentication.
    ///     When using this parameter, please make sure that the access token is sufficiently scoped down to only allow read access to that file and no other files or folders.
    public init(version: String? = nil, accessToken: String? = nil) {
        self.version = version
        self.accessToken = accessToken
    }

}
