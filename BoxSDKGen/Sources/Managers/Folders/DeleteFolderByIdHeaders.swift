import Foundation

public class DeleteFolderByIdHeaders {
    /// Ensures this item hasn't recently changed before
    /// making changes.
    /// 
    /// Pass in the item's last observed `etag` value
    /// into this header and the endpoint will fail
    /// with a `412 Precondition Failed` if it
    /// has changed since.
    public let ifMatch: String?

    /// Extra headers that will be included in the HTTP request.
    public let extraHeaders: [String: String?]?

    /// Initializer for a DeleteFolderByIdHeaders.
    ///
    /// - Parameters:
    ///   - ifMatch: Ensures this item hasn't recently changed before
    ///     making changes.
    ///     
    ///     Pass in the item's last observed `etag` value
    ///     into this header and the endpoint will fail
    ///     with a `412 Precondition Failed` if it
    ///     has changed since.
    ///   - extraHeaders: Extra headers that will be included in the HTTP request.
    public init(ifMatch: String? = nil, extraHeaders: [String: String?]? = [:]) {
        self.ifMatch = ifMatch
        self.extraHeaders = extraHeaders
    }

}
