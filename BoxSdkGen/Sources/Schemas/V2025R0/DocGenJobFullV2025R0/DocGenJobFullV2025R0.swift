import Foundation

/// A full representation of a Box Doc Gen job.
public class DocGenJobFullV2025R0: DocGenJobV2025R0 {
    private enum CodingKeys: String, CodingKey {
        case createdBy = "created_by"
        case enterprise
        case source
        case createdAt = "created_at"
    }

    public let createdBy: UserBaseV2025R0

    public let enterprise: EnterpriseReferenceV2025R0

    /// Source of the request.
    public let source: String

    /// Time of job creation.
    public let createdAt: String?

    /// Initializer for a DocGenJobFullV2025R0.
    ///
    /// - Parameters:
    ///   - id: The unique identifier that represent a Box Doc Gen job.
    ///   - batch: 
    ///   - templateFile: 
    ///   - templateFileVersion: 
    ///   - status: Status of the job.
    ///   - outputType: Type of the generated file.
    ///   - createdBy: 
    ///   - enterprise: 
    ///   - source: Source of the request.
    ///   - type: `docgen_job`
    ///   - outputFile: 
    ///   - outputFileVersion: 
    ///   - createdAt: Time of job creation.
    public init(id: String, batch: DocGenBatchBaseV2025R0, templateFile: FileReferenceV2025R0, templateFileVersion: FileVersionBaseV2025R0, status: DocGenJobV2025R0StatusField, outputType: String, createdBy: UserBaseV2025R0, enterprise: EnterpriseReferenceV2025R0, source: String, type: DocGenJobBaseV2025R0TypeField = DocGenJobBaseV2025R0TypeField.docgenJob, outputFile: FileReferenceV2025R0?? = nil, outputFileVersion: FileVersionBaseV2025R0?? = nil, createdAt: String? = nil) {
        self.createdBy = createdBy
        self.enterprise = enterprise
        self.source = source
        self.createdAt = createdAt

        super.init(id: id, batch: batch, templateFile: templateFile, templateFileVersion: templateFileVersion, status: status, outputType: outputType, type: type, outputFile: outputFile, outputFileVersion: outputFileVersion)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        createdBy = try container.decode(UserBaseV2025R0.self, forKey: .createdBy)
        enterprise = try container.decode(EnterpriseReferenceV2025R0.self, forKey: .enterprise)
        source = try container.decode(String.self, forKey: .source)
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(createdBy, forKey: .createdBy)
        try container.encode(enterprise, forKey: .enterprise)
        try container.encode(source, forKey: .source)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try super.encode(to: encoder)
    }

}
