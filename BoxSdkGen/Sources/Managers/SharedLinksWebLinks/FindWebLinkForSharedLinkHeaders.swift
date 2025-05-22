import Foundation

public class FindWebLinkForSharedLinkHeaders {
    /// A header containing the shared link and optional password for the
    /// shared link.
    /// 
    /// The format for this header is as follows.
    /// 
    /// `shared_link=[link]&shared_link_password=[password]`
    public let boxapi: String

    /// Ensures an item is only returned if it has changed.
    /// 
    /// Pass in the item's last observed `etag` value
    /// into this header and the endpoint will fail
    /// with a `304 Not Modified` if the item has not
    /// changed since.
    public let ifNoneMatch: String?

    /// Extra headers that will be included in the HTTP request.
    public let extraHeaders: [String: String?]?

    /// Initializer for a FindWebLinkForSharedLinkHeaders.
    ///
    /// - Parameters:
    ///   - boxapi: A header containing the shared link and optional password for the
    ///     shared link.
    ///     
    ///     The format for this header is as follows.
    ///     
    ///     `shared_link=[link]&shared_link_password=[password]`
    ///   - ifNoneMatch: Ensures an item is only returned if it has changed.
    ///     
    ///     Pass in the item's last observed `etag` value
    ///     into this header and the endpoint will fail
    ///     with a `304 Not Modified` if the item has not
    ///     changed since.
    ///   - extraHeaders: Extra headers that will be included in the HTTP request.
    public init(boxapi: String, ifNoneMatch: String? = nil, extraHeaders: [String: String?]? = [:]) {
        self.boxapi = boxapi
        self.ifNoneMatch = ifNoneMatch
        self.extraHeaders = extraHeaders
    }

}
