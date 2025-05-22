import Foundation

/// The schema for creating a Box Doc Gen job batch request.
public class DocGenBatchCreateRequestV2025R0: Codable {
    private enum CodingKeys: String, CodingKey {
        case file
        case inputSource = "input_source"
        case destinationFolder = "destination_folder"
        case outputType = "output_type"
        case documentGenerationData = "document_generation_data"
        case fileVersion = "file_version"
    }

    public let file: FileReferenceV2025R0

    /// Source of input. The value has to be `api` for all the API-based document generation requests.
    public let inputSource: String

    public let destinationFolder: DocGenBatchCreateRequestV2025R0DestinationFolderField

    /// Type of the output file.
    public let outputType: String

    public let documentGenerationData: [DocGenDocumentGenerationDataV2025R0]

    public let fileVersion: FileVersionBaseV2025R0?

    /// Initializer for a DocGenBatchCreateRequestV2025R0.
    ///
    /// - Parameters:
    ///   - file: 
    ///   - inputSource: Source of input. The value has to be `api` for all the API-based document generation requests.
    ///   - destinationFolder: 
    ///   - outputType: Type of the output file.
    ///   - documentGenerationData: 
    ///   - fileVersion: 
    public init(file: FileReferenceV2025R0, inputSource: String, destinationFolder: DocGenBatchCreateRequestV2025R0DestinationFolderField, outputType: String, documentGenerationData: [DocGenDocumentGenerationDataV2025R0], fileVersion: FileVersionBaseV2025R0? = nil) {
        self.file = file
        self.inputSource = inputSource
        self.destinationFolder = destinationFolder
        self.outputType = outputType
        self.documentGenerationData = documentGenerationData
        self.fileVersion = fileVersion
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        file = try container.decode(FileReferenceV2025R0.self, forKey: .file)
        inputSource = try container.decode(String.self, forKey: .inputSource)
        destinationFolder = try container.decode(DocGenBatchCreateRequestV2025R0DestinationFolderField.self, forKey: .destinationFolder)
        outputType = try container.decode(String.self, forKey: .outputType)
        documentGenerationData = try container.decode([DocGenDocumentGenerationDataV2025R0].self, forKey: .documentGenerationData)
        fileVersion = try container.decodeIfPresent(FileVersionBaseV2025R0.self, forKey: .fileVersion)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(file, forKey: .file)
        try container.encode(inputSource, forKey: .inputSource)
        try container.encode(destinationFolder, forKey: .destinationFolder)
        try container.encode(outputType, forKey: .outputType)
        try container.encode(documentGenerationData, forKey: .documentGenerationData)
        try container.encodeIfPresent(fileVersion, forKey: .fileVersion)
    }

}
