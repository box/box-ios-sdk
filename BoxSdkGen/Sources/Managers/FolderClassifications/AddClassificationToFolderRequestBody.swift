import Foundation

public class AddClassificationToFolderRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case boxSecurityClassificationKey = "Box__Security__Classification__Key"
    }

    /// The name of the classification to apply to this folder.
    /// 
    /// To list the available classifications in an enterprise,
    /// use the classification API to retrieve the
    /// [classification template](e://get_metadata_templates_enterprise_securityClassification-6VMVochwUWo_schema)
    /// which lists all available classification keys.
    public let boxSecurityClassificationKey: String?

    /// Initializer for a AddClassificationToFolderRequestBody.
    ///
    /// - Parameters:
    ///   - boxSecurityClassificationKey: The name of the classification to apply to this folder.
    ///     
    ///     To list the available classifications in an enterprise,
    ///     use the classification API to retrieve the
    ///     [classification template](e://get_metadata_templates_enterprise_securityClassification-6VMVochwUWo_schema)
    ///     which lists all available classification keys.
    public init(boxSecurityClassificationKey: String? = nil) {
        self.boxSecurityClassificationKey = boxSecurityClassificationKey
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        boxSecurityClassificationKey = try container.decodeIfPresent(String.self, forKey: .boxSecurityClassificationKey)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(boxSecurityClassificationKey, forKey: .boxSecurityClassificationKey)
    }

}
