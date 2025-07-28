import Foundation

public class UpdateClassificationOnFileRequestBody: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case value
        case op
        case path
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The name of the classification to apply to this file.
    /// 
    /// To list the available classifications in an enterprise,
    /// use the classification API to retrieve the
    /// [classification template](e://get_metadata_templates_enterprise_securityClassification-6VMVochwUWo_schema)
    /// which lists all available classification keys.
    public let value: String

    /// The value will always be `replace`.
    public let op: UpdateClassificationOnFileRequestBodyOpField

    /// Defines classifications 
    /// available in the enterprise.
    public let path: UpdateClassificationOnFileRequestBodyPathField

    /// Initializer for a UpdateClassificationOnFileRequestBody.
    ///
    /// - Parameters:
    ///   - value: The name of the classification to apply to this file.
    ///     
    ///     To list the available classifications in an enterprise,
    ///     use the classification API to retrieve the
    ///     [classification template](e://get_metadata_templates_enterprise_securityClassification-6VMVochwUWo_schema)
    ///     which lists all available classification keys.
    ///   - op: The value will always be `replace`.
    ///   - path: Defines classifications 
    ///     available in the enterprise.
    public init(value: String, op: UpdateClassificationOnFileRequestBodyOpField = UpdateClassificationOnFileRequestBodyOpField.replace, path: UpdateClassificationOnFileRequestBodyPathField = UpdateClassificationOnFileRequestBodyPathField.boxSecurityClassificationKey) {
        self.value = value
        self.op = op
        self.path = path
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = try container.decode(String.self, forKey: .value)
        op = try container.decode(UpdateClassificationOnFileRequestBodyOpField.self, forKey: .op)
        path = try container.decode(UpdateClassificationOnFileRequestBodyPathField.self, forKey: .path)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .value)
        try container.encode(op, forKey: .op)
        try container.encode(path, forKey: .path)
    }

    /// Sets the raw JSON data.
    ///
    /// - Parameters:
    ///   - rawData: A dictionary containing the raw JSON data
    func setRawData(rawData: [String: Any]?) {
        self._rawData = rawData
    }

    /// Gets the raw JSON data
    /// - Returns: The `[String: Any]?`.
    func getRawData() -> [String: Any]? {
        return self._rawData
    }

}
