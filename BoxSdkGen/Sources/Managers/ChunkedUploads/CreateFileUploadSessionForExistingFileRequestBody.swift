import Foundation

public class CreateFileUploadSessionForExistingFileRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case fileSize = "file_size"
        case fileName = "file_name"
    }

    /// The total number of bytes of the file to be uploaded
    public let fileSize: Int64

    /// The optional new name of new file
    public let fileName: String?

    /// Initializer for a CreateFileUploadSessionForExistingFileRequestBody.
    ///
    /// - Parameters:
    ///   - fileSize: The total number of bytes of the file to be uploaded
    ///   - fileName: The optional new name of new file
    public init(fileSize: Int64, fileName: String? = nil) {
        self.fileSize = fileSize
        self.fileName = fileName
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        fileSize = try container.decode(Int64.self, forKey: .fileSize)
        fileName = try container.decodeIfPresent(String.self, forKey: .fileName)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fileSize, forKey: .fileSize)
        try container.encodeIfPresent(fileName, forKey: .fileName)
    }

}
