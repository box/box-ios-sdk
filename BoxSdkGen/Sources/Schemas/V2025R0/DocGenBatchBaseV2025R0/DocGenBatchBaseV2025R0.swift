import Foundation

/// The basic representation of a Box Doc Gen batch object. A Box Doc Gen batch contains one or more Box Doc Gen jobs.
public class DocGenBatchBaseV2025R0: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// The unique identifier that represents a Box Doc Gen batch.
    public let id: String

    /// `docgen_batch`
    public let type: DocGenBatchBaseV2025R0TypeField

    /// Initializer for a DocGenBatchBaseV2025R0.
    ///
    /// - Parameters:
    ///   - id: The unique identifier that represents a Box Doc Gen batch.
    ///   - type: `docgen_batch`
    public init(id: String, type: DocGenBatchBaseV2025R0TypeField = DocGenBatchBaseV2025R0TypeField.docgenBatch) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(DocGenBatchBaseV2025R0TypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
    }

}
