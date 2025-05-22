import Foundation

public class UploadFilePartHeaders {
    /// The [RFC3230][1] message digest of the chunk uploaded.
    /// 
    /// Only SHA1 is supported. The SHA1 digest must be base64
    /// encoded. The format of this header is as
    /// `sha=BASE64_ENCODED_DIGEST`.
    /// 
    /// To get the value for the `SHA` digest, use the
    /// openSSL command to encode the file part:
    /// `openssl sha1 -binary <FILE_PART_NAME> | base64`
    /// 
    /// [1]: https://tools.ietf.org/html/rfc3230
    public let digest: String

    /// The byte range of the chunk.
    /// 
    /// Must not overlap with the range of a part already
    /// uploaded this session. Each part’s size must be
    /// exactly equal in size to the part size specified
    /// in the upload session that you created.
    /// One exception is the last part of the file, as this can be smaller.
    /// 
    /// When providing the value for `content-range`, remember that:
    /// 
    /// * The lower bound of each part's byte range
    ///   must be a multiple of the part size.
    /// * The higher bound must be a multiple of the part size - 1.
    public let contentRange: String

    /// Extra headers that will be included in the HTTP request.
    public let extraHeaders: [String: String?]?

    /// Initializer for a UploadFilePartHeaders.
    ///
    /// - Parameters:
    ///   - digest: The [RFC3230][1] message digest of the chunk uploaded.
    ///     
    ///     Only SHA1 is supported. The SHA1 digest must be base64
    ///     encoded. The format of this header is as
    ///     `sha=BASE64_ENCODED_DIGEST`.
    ///     
    ///     To get the value for the `SHA` digest, use the
    ///     openSSL command to encode the file part:
    ///     `openssl sha1 -binary <FILE_PART_NAME> | base64`
    ///     
    ///     [1]: https://tools.ietf.org/html/rfc3230
    ///   - contentRange: The byte range of the chunk.
    ///     
    ///     Must not overlap with the range of a part already
    ///     uploaded this session. Each part’s size must be
    ///     exactly equal in size to the part size specified
    ///     in the upload session that you created.
    ///     One exception is the last part of the file, as this can be smaller.
    ///     
    ///     When providing the value for `content-range`, remember that:
    ///     
    ///     * The lower bound of each part's byte range
    ///       must be a multiple of the part size.
    ///     * The higher bound must be a multiple of the part size - 1.
    ///   - extraHeaders: Extra headers that will be included in the HTTP request.
    public init(digest: String, contentRange: String, extraHeaders: [String: String?]? = [:]) {
        self.digest = digest
        self.contentRange = contentRange
        self.extraHeaders = extraHeaders
    }

}
