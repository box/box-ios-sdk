import Foundation

public class UpdateClassificationOnFolderRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case value
        case op
        case path
    }

    /// The name of the classification to apply to this folder.
    /// 
    /// To list the available classifications in an enterprise,
    /// use the classification API to retrieve the
    /// [classification template](e://get_metadata_templates_enterprise_securityClassification-6VMVochwUWo_schema)
    /// which lists all available classification keys.
    public let value: String

    /// `replace`
    public let op: UpdateClassificationOnFolderRequestBodyOpField

    /// Defines classifications 
    /// available in the enterprise.
    public let path: UpdateClassificationOnFolderRequestBodyPathField

    /// Initializer for a UpdateClassificationOnFolderRequestBody.
    ///
    /// - Parameters:
    ///   - value: The name of the classification to apply to this folder.
    ///     
    ///     To list the available classifications in an enterprise,
    ///     use the classification API to retrieve the
    ///     [classification template](e://get_metadata_templates_enterprise_securityClassification-6VMVochwUWo_schema)
    ///     which lists all available classification keys.
    ///   - op: `replace`
    ///   - path: Defines classifications 
    ///     available in the enterprise.
    public init(value: String, op: UpdateClassificationOnFolderRequestBodyOpField = UpdateClassificationOnFolderRequestBodyOpField.replace, path: UpdateClassificationOnFolderRequestBodyPathField = UpdateClassificationOnFolderRequestBodyPathField.boxSecurityClassificationKey) {
        self.value = value
        self.op = op
        self.path = path
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = try container.decode(String.self, forKey: .value)
        op = try container.decode(UpdateClassificationOnFolderRequestBodyOpField.self, forKey: .op)
        path = try container.decode(UpdateClassificationOnFolderRequestBodyPathField.self, forKey: .path)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .value)
        try container.encode(op, forKey: .op)
        try container.encode(path, forKey: .path)
    }

}
