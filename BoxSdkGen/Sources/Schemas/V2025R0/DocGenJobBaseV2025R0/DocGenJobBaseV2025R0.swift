import Foundation

/// The basic representation of a Box Doc Gen job.
public class DocGenJobBaseV2025R0: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// The unique identifier that represent a Box Doc Gen job.
    public let id: String

    /// `docgen_job`
    public let type: DocGenJobBaseV2025R0TypeField

    /// Initializer for a DocGenJobBaseV2025R0.
    ///
    /// - Parameters:
    ///   - id: The unique identifier that represent a Box Doc Gen job.
    ///   - type: `docgen_job`
    public init(id: String, type: DocGenJobBaseV2025R0TypeField = DocGenJobBaseV2025R0TypeField.docgenJob) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(DocGenJobBaseV2025R0TypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
    }

}
