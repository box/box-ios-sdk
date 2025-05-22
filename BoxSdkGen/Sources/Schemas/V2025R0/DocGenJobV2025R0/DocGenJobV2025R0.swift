import Foundation

/// A standard representation of a Box Doc Gen job.
public class DocGenJobV2025R0: DocGenJobBaseV2025R0 {
    private enum CodingKeys: String, CodingKey {
        case batch
        case templateFile = "template_file"
        case templateFileVersion = "template_file_version"
        case status
        case outputType = "output_type"
        case outputFile = "output_file"
        case outputFileVersion = "output_file_version"
    }

    public let batch: DocGenBatchBaseV2025R0

    public let templateFile: FileReferenceV2025R0

    public let templateFileVersion: FileVersionBaseV2025R0

    /// Status of the job.
    public let status: DocGenJobV2025R0StatusField

    /// Type of the generated file.
    public let outputType: String

    public let outputFile: FileReferenceV2025R0??

    public let outputFileVersion: FileVersionBaseV2025R0??

    /// Initializer for a DocGenJobV2025R0.
    ///
    /// - Parameters:
    ///   - id: The unique identifier that represent a Box Doc Gen job.
    ///   - batch: 
    ///   - templateFile: 
    ///   - templateFileVersion: 
    ///   - status: Status of the job.
    ///   - outputType: Type of the generated file.
    ///   - type: `docgen_job`
    ///   - outputFile: 
    ///   - outputFileVersion: 
    public init(id: String, batch: DocGenBatchBaseV2025R0, templateFile: FileReferenceV2025R0, templateFileVersion: FileVersionBaseV2025R0, status: DocGenJobV2025R0StatusField, outputType: String, type: DocGenJobBaseV2025R0TypeField = DocGenJobBaseV2025R0TypeField.docgenJob, outputFile: FileReferenceV2025R0?? = nil, outputFileVersion: FileVersionBaseV2025R0?? = nil) {
        self.batch = batch
        self.templateFile = templateFile
        self.templateFileVersion = templateFileVersion
        self.status = status
        self.outputType = outputType
        self.outputFile = outputFile
        self.outputFileVersion = outputFileVersion

        super.init(id: id, type: type)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        batch = try container.decode(DocGenBatchBaseV2025R0.self, forKey: .batch)
        templateFile = try container.decode(FileReferenceV2025R0.self, forKey: .templateFile)
        templateFileVersion = try container.decode(FileVersionBaseV2025R0.self, forKey: .templateFileVersion)
        status = try container.decode(DocGenJobV2025R0StatusField.self, forKey: .status)
        outputType = try container.decode(String.self, forKey: .outputType)
        outputFile = try container.decodeIfPresent(FileReferenceV2025R0?.self, forKey: .outputFile)
        outputFileVersion = try container.decodeIfPresent(FileVersionBaseV2025R0?.self, forKey: .outputFileVersion)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(batch, forKey: .batch)
        try container.encode(templateFile, forKey: .templateFile)
        try container.encode(templateFileVersion, forKey: .templateFileVersion)
        try container.encode(status, forKey: .status)
        try container.encode(outputType, forKey: .outputType)
        try container.encodeIfPresent(outputFile, forKey: .outputFile)
        try container.encodeIfPresent(outputFileVersion, forKey: .outputFileVersion)
        try super.encode(to: encoder)
    }

}
