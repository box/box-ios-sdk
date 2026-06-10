import Foundation

/// A taxonomy source to be used for the structured extraction. It can either be an existing CSV file or a taxonomy.
public enum AiTaxonomySource: Codable {
    case aiTaxonomyReference(AiTaxonomyReference)
    case aiTaxonomyFileReference(AiTaxonomyFileReference)

    private enum DiscriminatorCodingKey: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: DiscriminatorCodingKey.self) {
            if let discriminator_0 = try? container.decode(String.self, forKey: .type) {
                switch discriminator_0 {
                case "taxonomy":
                    if let content = try? AiTaxonomyReference(from: decoder) {
                        self = .aiTaxonomyReference(content)
                        return
                    }

                case "file":
                    if let content = try? AiTaxonomyFileReference(from: decoder) {
                        self = .aiTaxonomyFileReference(content)
                        return
                    }

                default:
                    break
                }
            }

        }

        throw DecodingError.typeMismatch(AiTaxonomySource.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The type of the decoded object cannot be determined."))

    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .aiTaxonomyReference(let aiTaxonomyReference):
            try aiTaxonomyReference.encode(to: encoder)
        case .aiTaxonomyFileReference(let aiTaxonomyFileReference):
            try aiTaxonomyFileReference.encode(to: encoder)
        }
    }

}
