import Foundation

public class CreateFileUploadSessionRequestBody: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case folderId = "folder_id"
        case fileSize = "file_size"
        case fileName = "file_name"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The ID of the folder to upload the new file to.
    public let folderId: String

    /// The total number of bytes of the file to be uploaded.
    public let fileSize: Int64

    /// The name of new file.
    public let fileName: String

    /// Initializer for a CreateFileUploadSessionRequestBody.
    ///
    /// - Parameters:
    ///   - folderId: The ID of the folder to upload the new file to.
    ///   - fileSize: The total number of bytes of the file to be uploaded.
    ///   - fileName: The name of new file.
    public init(folderId: String, fileSize: Int64, fileName: String) {
        self.folderId = folderId
        self.fileSize = fileSize
        self.fileName = fileName
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        folderId = try container.decode(String.self, forKey: .folderId)
        fileSize = try container.decode(Int64.self, forKey: .fileSize)
        fileName = try container.decode(String.self, forKey: .fileName)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(folderId, forKey: .folderId)
        try container.encode(fileSize, forKey: .fileSize)
        try container.encode(fileName, forKey: .fileName)
    }

    /// Sets the raw JSON data.
    ///
    /// - Parameters:
    ///   - rawData: A dictionary containing the raw JSON data
    func setRawData(rawData: [String: Any]?) {
        self._rawData = rawData
    }

    /// Gets the raw JSON data
    /// - Returns: The `[String: Any]?`.
    func getRawData() -> [String: Any]? {
        return self._rawData
    }

}
