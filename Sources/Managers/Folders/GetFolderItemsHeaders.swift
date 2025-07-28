import Foundation

public class GetFolderItemsHeaders {
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

    /// Initializer for a GetFolderItemsHeaders.
    ///
    /// - Parameters:
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
    public init(boxapi: String? = nil, extraHeaders: [String: String?]? = [:]) {
        self.boxapi = boxapi
        self.extraHeaders = extraHeaders
    }

}
