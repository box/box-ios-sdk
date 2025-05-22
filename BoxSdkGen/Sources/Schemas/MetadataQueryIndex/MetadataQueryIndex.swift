import Foundation

/// A metadata query index
public class MetadataQueryIndex: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
        case status
        case id
        case fields
    }

    /// Value is always `metadata_query_index`
    public let type: String

    /// The status of the metadata query index
    public let status: MetadataQueryIndexStatusField

    /// The ID of the metadata query index.
    public let id: String?

    /// A list of template fields which make up the index.
    public let fields: [MetadataQueryIndexFieldsField]?

    /// Initializer for a MetadataQueryIndex.
    ///
    /// - Parameters:
    ///   - type: Value is always `metadata_query_index`
    ///   - status: The status of the metadata query index
    ///   - id: The ID of the metadata query index.
    ///   - fields: A list of template fields which make up the index.
    public init(type: String, status: MetadataQueryIndexStatusField, id: String? = nil, fields: [MetadataQueryIndexFieldsField]? = nil) {
        self.type = type
        self.status = status
        self.id = id
        self.fields = fields
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(String.self, forKey: .type)
        status = try container.decode(MetadataQueryIndexStatusField.self, forKey: .status)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        fields = try container.decodeIfPresent([MetadataQueryIndexFieldsField].self, forKey: .fields)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(status, forKey: .status)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(fields, forKey: .fields)
    }

}
