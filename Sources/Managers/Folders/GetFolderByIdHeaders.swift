import Foundation

public class GetFolderByIdHeaders {
    /// Ensures an item is only returned if it has changed.
    /// 
    /// Pass in the item's last observed `etag` value
    /// into this header and the endpoint will fail
    /// with a `304 Not Modified` if the item has not
    /// changed since.
    public let ifNoneMatch: String?

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

    /// Initializer for a GetFolderByIdHeaders.
    ///
    /// - Parameters:
    ///   - ifNoneMatch: Ensures an item is only returned if it has changed.
    ///     
    ///     Pass in the item's last observed `etag` value
    ///     into this header and the endpoint will fail
    ///     with a `304 Not Modified` if the item has not
    ///     changed since.
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
    public init(ifNoneMatch: String? = nil, boxapi: String? = nil, extraHeaders: [String: String?]? = [:]) {
        self.ifNoneMatch = ifNoneMatch
        self.boxapi = boxapi
        self.extraHeaders = extraHeaders
    }

}
