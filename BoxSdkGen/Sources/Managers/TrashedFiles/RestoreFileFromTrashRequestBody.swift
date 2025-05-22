import Foundation

public class RestoreFileFromTrashRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case name
        case parent
    }

    /// An optional new name for the file.
    public let name: String?

    public let parent: RestoreFileFromTrashRequestBodyParentField?

    /// Initializer for a RestoreFileFromTrashRequestBody.
    ///
    /// - Parameters:
    ///   - name: An optional new name for the file.
    ///   - parent: 
    public init(name: String? = nil, parent: RestoreFileFromTrashRequestBodyParentField? = nil) {
        self.name = name
        self.parent = parent
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        parent = try container.decodeIfPresent(RestoreFileFromTrashRequestBodyParentField.self, forKey: .parent)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(parent, forKey: .parent)
    }

}
