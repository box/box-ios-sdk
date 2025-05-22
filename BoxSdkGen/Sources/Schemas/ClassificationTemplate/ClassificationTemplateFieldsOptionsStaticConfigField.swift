import Foundation

public class ClassificationTemplateFieldsOptionsStaticConfigField: Codable {
    private enum CodingKeys: String, CodingKey {
        case classification
    }

    /// Additional information about the classification.
    /// 
    /// This is not an exclusive list of properties, and
    /// more object fields might be returned. These fields
    /// are used for internal Box Shield and Box Governance
    /// purposes and no additional value must be derived from
    /// these fields.
    public let classification: ClassificationTemplateFieldsOptionsStaticConfigClassificationField?

    /// Initializer for a ClassificationTemplateFieldsOptionsStaticConfigField.
    ///
    /// - Parameters:
    ///   - classification: Additional information about the classification.
    ///     
    ///     This is not an exclusive list of properties, and
    ///     more object fields might be returned. These fields
    ///     are used for internal Box Shield and Box Governance
    ///     purposes and no additional value must be derived from
    ///     these fields.
    public init(classification: ClassificationTemplateFieldsOptionsStaticConfigClassificationField? = nil) {
        self.classification = classification
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        classification = try container.decodeIfPresent(ClassificationTemplateFieldsOptionsStaticConfigClassificationField.self, forKey: .classification)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(classification, forKey: .classification)
    }

}
