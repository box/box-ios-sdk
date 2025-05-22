import Foundation

public class FindAppItemForSharedLinkHeaders {
    /// A header containing the shared link and optional password for the
    /// shared link.
    /// 
    /// The format for this header is `shared_link=[link]&shared_link_password=[password]`
    public let boxapi: String

    /// Extra headers that will be included in the HTTP request.
    public let extraHeaders: [String: String?]?

    /// Initializer for a FindAppItemForSharedLinkHeaders.
    ///
    /// - Parameters:
    ///   - boxapi: A header containing the shared link and optional password for the
    ///     shared link.
    ///     
    ///     The format for this header is `shared_link=[link]&shared_link_password=[password]`
    ///   - extraHeaders: Extra headers that will be included in the HTTP request.
    public init(boxapi: String, extraHeaders: [String: String?]? = [:]) {
        self.boxapi = boxapi
        self.extraHeaders = extraHeaders
    }

}
