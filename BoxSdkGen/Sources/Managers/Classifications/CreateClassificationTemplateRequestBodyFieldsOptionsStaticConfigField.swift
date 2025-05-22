import Foundation

public class CreateClassificationTemplateRequestBodyFieldsOptionsStaticConfigField: Codable {
    private enum CodingKeys: String, CodingKey {
        case classification
    }

    /// Additional information about the classification.
    public let classification: CreateClassificationTemplateRequestBodyFieldsOptionsStaticConfigClassificationField?

    /// Initializer for a CreateClassificationTemplateRequestBodyFieldsOptionsStaticConfigField.
    ///
    /// - Parameters:
    ///   - classification: Additional information about the classification.
    public init(classification: CreateClassificationTemplateRequestBodyFieldsOptionsStaticConfigClassificationField? = nil) {
        self.classification = classification
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        classification = try container.decodeIfPresent(CreateClassificationTemplateRequestBodyFieldsOptionsStaticConfigClassificationField.self, forKey: .classification)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(classification, forKey: .classification)
    }

}
