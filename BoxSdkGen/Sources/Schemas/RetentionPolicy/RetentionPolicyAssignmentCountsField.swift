import Foundation

public class RetentionPolicyAssignmentCountsField: Codable {
    private enum CodingKeys: String, CodingKey {
        case enterprise
        case folder
        case metadataTemplate = "metadata_template"
    }

    /// The number of enterprise assignments this policy has. The maximum value is 1.
    public let enterprise: Int64?

    /// The number of folder assignments this policy has.
    public let folder: Int64?

    /// The number of metadata template assignments this policy has.
    public let metadataTemplate: Int64?

    /// Initializer for a RetentionPolicyAssignmentCountsField.
    ///
    /// - Parameters:
    ///   - enterprise: The number of enterprise assignments this policy has. The maximum value is 1.
    ///   - folder: The number of folder assignments this policy has.
    ///   - metadataTemplate: The number of metadata template assignments this policy has.
    public init(enterprise: Int64? = nil, folder: Int64? = nil, metadataTemplate: Int64? = nil) {
        self.enterprise = enterprise
        self.folder = folder
        self.metadataTemplate = metadataTemplate
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        enterprise = try container.decodeIfPresent(Int64.self, forKey: .enterprise)
        folder = try container.decodeIfPresent(Int64.self, forKey: .folder)
        metadataTemplate = try container.decodeIfPresent(Int64.self, forKey: .metadataTemplate)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(enterprise, forKey: .enterprise)
        try container.encodeIfPresent(folder, forKey: .folder)
        try container.encodeIfPresent(metadataTemplate, forKey: .metadataTemplate)
    }

}
