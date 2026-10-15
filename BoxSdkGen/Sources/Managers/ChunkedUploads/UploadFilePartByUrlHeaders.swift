import Foundation

public class UploadFilePartByUrlHeaders {
    /// The [RFC3230][1] message digest of the chunk uploaded.
    /// 
    /// `SHA-1` and `SHA-512` ([RFC5843][2]) are supported. The digest must be base64
    /// encoded. The format of this header is as
    /// `sha=BASE64_ENCODED_DIGEST` for `SHA-1`, or
    /// `sha-512=BASE64_ENCODED_DIGEST` for `SHA-512`.
    /// 
    /// To get the value for the digest, use the
    /// openSSL command to encode the file part:
    /// `openssl sha1 -binary <FILE_PART_NAME> | base64` for `SHA-1`, or
    /// `openssl sha512 -binary <FILE_PART_NAME> | base64` for `SHA-512`.
    /// 
    /// [1]: https://tools.ietf.org/html/rfc3230
    /// [2]: https://tools.ietf.org/html/rfc5843
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

    /// Initializer for a UploadFilePartByUrlHeaders.
    ///
    /// - Parameters:
    ///   - digest: The [RFC3230][1] message digest of the chunk uploaded.
    ///     
    ///     `SHA-1` and `SHA-512` ([RFC5843][2]) are supported. The digest must be base64
    ///     encoded. The format of this header is as
    ///     `sha=BASE64_ENCODED_DIGEST` for `SHA-1`, or
    ///     `sha-512=BASE64_ENCODED_DIGEST` for `SHA-512`.
    ///     
    ///     To get the value for the digest, use the
    ///     openSSL command to encode the file part:
    ///     `openssl sha1 -binary <FILE_PART_NAME> | base64` for `SHA-1`, or
    ///     `openssl sha512 -binary <FILE_PART_NAME> | base64` for `SHA-512`.
    ///     
    ///     [1]: https://tools.ietf.org/html/rfc3230
    ///     [2]: https://tools.ietf.org/html/rfc5843
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
