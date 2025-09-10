import Foundation

/// Multipart item for multipart data
public class MultipartItem {
    /// Name of the part
    public let partName: String

    /// Data of the part
    public let data: SerializedData?

    /// File stream of the part
    public let fileStream: InputStream?

    /// File name of the part
    public let fileName: String?

    /// Content type of the part
    public let contentType: String?

    /// Initializer for a MultipartItem.
    ///
    /// - Parameters:
    ///   - partName: Name of the part
    ///   - data: Data of the part
    ///   - fileStream: File stream of the part
    ///   - fileName: File name of the part
    ///   - contentType: Content type of the part
    public init(partName: String, data: SerializedData? = nil, fileStream: InputStream? = nil, fileName: String? = nil, contentType: String? = nil) {
        self.partName = partName
        self.data = data
        self.fileStream = fileStream
        self.fileName = fileName
        self.contentType = contentType
    }

}
