import Foundation

public class UploadFileHeaders {
    /// An optional header containing the SHA1 hash of the file to
    /// ensure that the file was not corrupted in transit.
    public let contentMd5: String?

    /// Extra headers that will be included in the HTTP request.
    public let extraHeaders: [String: String?]?

    /// Initializer for a UploadFileHeaders.
    ///
    /// - Parameters:
    ///   - contentMd5: An optional header containing the SHA1 hash of the file to
    ///     ensure that the file was not corrupted in transit.
    ///   - extraHeaders: Extra headers that will be included in the HTTP request.
    public init(contentMd5: String? = nil, extraHeaders: [String: String?]? = [:]) {
        self.contentMd5 = contentMd5
        self.extraHeaders = extraHeaders
    }

}
