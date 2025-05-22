import Foundation

public class PreflightFileUploadCheckRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case name
        case size
        case parent
    }

    /// The name for the file
    public let name: String?

    /// The size of the file in bytes
    public let size: Int?

    public let parent: PreflightFileUploadCheckRequestBodyParentField?

    /// Initializer for a PreflightFileUploadCheckRequestBody.
    ///
    /// - Parameters:
    ///   - name: The name for the file
    ///   - size: The size of the file in bytes
    ///   - parent: 
    public init(name: String? = nil, size: Int? = nil, parent: PreflightFileUploadCheckRequestBodyParentField? = nil) {
        self.name = name
        self.size = size
        self.parent = parent
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        size = try container.decodeIfPresent(Int.self, forKey: .size)
        parent = try container.decodeIfPresent(PreflightFileUploadCheckRequestBodyParentField.self, forKey: .parent)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(size, forKey: .size)
        try container.encodeIfPresent(parent, forKey: .parent)
    }

}
