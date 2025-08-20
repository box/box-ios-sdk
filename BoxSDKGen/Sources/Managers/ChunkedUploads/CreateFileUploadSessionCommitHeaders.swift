import Foundation

public class CreateFileUploadSessionCommitHeaders {
    /// The [RFC3230][1] message digest of the whole file.
    /// 
    /// Only SHA1 is supported. The SHA1 digest must be Base64
    /// encoded. The format of this header is as
    /// `sha=BASE64_ENCODED_DIGEST`.
    /// 
    /// [1]: https://tools.ietf.org/html/rfc3230
    public let digest: String

    /// Ensures this item hasn't recently changed before
    /// making changes.
    /// 
    /// Pass in the item's last observed `etag` value
    /// into this header and the endpoint will fail
    /// with a `412 Precondition Failed` if it
    /// has changed since.
    public let ifMatch: String?

    /// Ensures an item is only returned if it has changed.
    /// 
    /// Pass in the item's last observed `etag` value
    /// into this header and the endpoint will fail
    /// with a `304 Not Modified` if the item has not
    /// changed since.
    public let ifNoneMatch: String?

    /// Extra headers that will be included in the HTTP request.
    public let extraHeaders: [String: String?]?

    /// Initializer for a CreateFileUploadSessionCommitHeaders.
    ///
    /// - Parameters:
    ///   - digest: The [RFC3230][1] message digest of the whole file.
    ///     
    ///     Only SHA1 is supported. The SHA1 digest must be Base64
    ///     encoded. The format of this header is as
    ///     `sha=BASE64_ENCODED_DIGEST`.
    ///     
    ///     [1]: https://tools.ietf.org/html/rfc3230
    ///   - ifMatch: Ensures this item hasn't recently changed before
    ///     making changes.
    ///     
    ///     Pass in the item's last observed `etag` value
    ///     into this header and the endpoint will fail
    ///     with a `412 Precondition Failed` if it
    ///     has changed since.
    ///   - ifNoneMatch: Ensures an item is only returned if it has changed.
    ///     
    ///     Pass in the item's last observed `etag` value
    ///     into this header and the endpoint will fail
    ///     with a `304 Not Modified` if the item has not
    ///     changed since.
    ///   - extraHeaders: Extra headers that will be included in the HTTP request.
    public init(digest: String, ifMatch: String? = nil, ifNoneMatch: String? = nil, extraHeaders: [String: String?]? = [:]) {
        self.digest = digest
        self.ifMatch = ifMatch
        self.ifNoneMatch = ifNoneMatch
        self.extraHeaders = extraHeaders
    }

}
