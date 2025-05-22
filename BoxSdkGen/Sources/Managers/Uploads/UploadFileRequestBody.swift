import Foundation

public class UploadFileRequestBody {
    /// The additional attributes of the file being uploaded. Mainly the
    /// name and the parent folder. These attributes are part of the multi
    /// part request body and are in JSON format.
    /// 
    /// <Message warning>
    /// 
    ///   The `attributes` part of the body must come **before** the
    ///   `file` part. Requests that do not follow this format when
    ///   uploading the file will receive a HTTP `400` error with a
    ///   `metadata_after_file_contents` error code.
    /// 
    /// </Message>
    public let attributes: UploadFileRequestBodyAttributesField

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

    /// Initializer for a UploadFileRequestBody.
    ///
    /// - Parameters:
    ///   - attributes: The additional attributes of the file being uploaded. Mainly the
    ///     name and the parent folder. These attributes are part of the multi
    ///     part request body and are in JSON format.
    ///     
    ///     <Message warning>
    ///     
    ///       The `attributes` part of the body must come **before** the
    ///       `file` part. Requests that do not follow this format when
    ///       uploading the file will receive a HTTP `400` error with a
    ///       `metadata_after_file_contents` error code.
    ///     
    ///     </Message>
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
    public init(attributes: UploadFileRequestBodyAttributesField, file: InputStream, fileFileName: String? = nil, fileContentType: String? = nil) {
        self.attributes = attributes
        self.file = file
        self.fileFileName = fileFileName
        self.fileContentType = fileContentType
    }

}
