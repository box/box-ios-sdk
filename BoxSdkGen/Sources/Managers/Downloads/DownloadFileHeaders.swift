import Foundation

public class DownloadFileHeaders {
    /// The byte range of the content to download.
    /// 
    /// The format `bytes={start_byte}-{end_byte}` can be used to specify
    /// what section of the file to download.
    public let range: String?

    /// The URL, and optional password, for the shared link of this item.
    /// 
    /// This header can be used to access items that have not been
    /// explicitly shared with a user.
    /// 
    /// Use the format `shared_link=[link]` or if a password is required then
    /// use `shared_link=[link]&shared_link_password=[password]`.
    /// 
    /// This header can be used on the file or folder shared, as well as on any files
    /// or folders nested within the item.
    public let boxapi: String?

    /// Extra headers that will be included in the HTTP request.
    public let extraHeaders: [String: String?]?

    /// Initializer for a DownloadFileHeaders.
    ///
    /// - Parameters:
    ///   - range: The byte range of the content to download.
    ///     
    ///     The format `bytes={start_byte}-{end_byte}` can be used to specify
    ///     what section of the file to download.
    ///   - boxapi: The URL, and optional password, for the shared link of this item.
    ///     
    ///     This header can be used to access items that have not been
    ///     explicitly shared with a user.
    ///     
    ///     Use the format `shared_link=[link]` or if a password is required then
    ///     use `shared_link=[link]&shared_link_password=[password]`.
    ///     
    ///     This header can be used on the file or folder shared, as well as on any files
    ///     or folders nested within the item.
    ///   - extraHeaders: Extra headers that will be included in the HTTP request.
    public init(range: String? = nil, boxapi: String? = nil, extraHeaders: [String: String?]? = [:]) {
        self.range = range
        self.boxapi = boxapi
        self.extraHeaders = extraHeaders
    }

}
