import Foundation

public class UploadFileVersionHeaders {
    /// Ensures this item hasn't recently changed before
    /// making changes.
    /// 
    /// Pass in the item's last observed `etag` value
    /// into this header and the endpoint will fail
    /// with a `412 Precondition Failed` if it
    /// has changed since.
    public let ifMatch: String?

    /// An optional header containing the SHA1 hash of the file to
    /// ensure that the file was not corrupted in transit.
    public let contentMd5: String?

    /// Extra headers that will be included in the HTTP request.
    public let extraHeaders: [String: String?]?

    /// Initializer for a UploadFileVersionHeaders.
    ///
    /// - Parameters:
    ///   - ifMatch: Ensures this item hasn't recently changed before
    ///     making changes.
    ///     
    ///     Pass in the item's last observed `etag` value
    ///     into this header and the endpoint will fail
    ///     with a `412 Precondition Failed` if it
    ///     has changed since.
    ///   - contentMd5: An optional header containing the SHA1 hash of the file to
    ///     ensure that the file was not corrupted in transit.
    ///   - extraHeaders: Extra headers that will be included in the HTTP request.
    public init(ifMatch: String? = nil, contentMd5: String? = nil, extraHeaders: [String: String?]? = [:]) {
        self.ifMatch = ifMatch
        self.contentMd5 = contentMd5
        self.extraHeaders = extraHeaders
    }

}
