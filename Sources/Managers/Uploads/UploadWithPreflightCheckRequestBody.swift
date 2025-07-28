import Foundation

public class UploadWithPreflightCheckRequestBody {
    public let attributes: UploadWithPreflightCheckRequestBodyAttributesField

    /// The content of the file to upload to Box.
    /// 
    /// <Message warning>
    /// 
    ///   The `attributes` part of the body must come **before** the
    ///   `file` part. Requests that do not follow this format when
    ///   uploading the file will receive a HTTP `400` error with a
    ///   `metadata_after_file_contents` error code.
    /// 
    /// </Message>
    public let file: InputStream

    public let fileFileName: String?

    public let fileContentType: String?

    /// Initializer for a UploadWithPreflightCheckRequestBody.
    ///
    /// - Parameters:
    ///   - attributes: 
    ///   - file: The content of the file to upload to Box.
    ///     
    ///     <Message warning>
    ///     
    ///       The `attributes` part of the body must come **before** the
    ///       `file` part. Requests that do not follow this format when
    ///       uploading the file will receive a HTTP `400` error with a
    ///       `metadata_after_file_contents` error code.
    ///     
    ///     </Message>
    ///   - fileFileName: 
    ///   - fileContentType: 
    public init(attributes: UploadWithPreflightCheckRequestBodyAttributesField, file: InputStream, fileFileName: String? = nil, fileContentType: String? = nil) {
        self.attributes = attributes
        self.file = file
        self.fileFileName = fileFileName
        self.fileContentType = fileContentType
    }

}
