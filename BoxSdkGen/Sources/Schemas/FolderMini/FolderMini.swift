import Foundation

/// A mini representation of a file version, used when
/// nested under another resource.
public class FolderMini: FolderBase {
    private enum CodingKeys: String, CodingKey {
        case sequenceId = "sequence_id"
        case name
    }

    public let sequenceId: String?

    /// The name of the folder.
    public let name: String?

    /// Initializer for a FolderMini.
    ///
    /// - Parameters:
    ///   - id: The unique identifier that represent a folder.
    ///     
    ///     The ID for any folder can be determined
    ///     by visiting a folder in the web application
    ///     and copying the ID from the URL. For example,
    ///     for the URL `https://*.app.box.com/folders/123`
    ///     the `folder_id` is `123`.
    ///   - etag: The HTTP `etag` of this folder. This can be used within some API
    ///     endpoints in the `If-Match` and `If-None-Match` headers to only
    ///     perform changes on the folder if (no) changes have happened.
    ///   - type: `folder`
    ///   - sequenceId: 
    ///   - name: The name of the folder.
    public init(id: String, etag: TriStateField<String> = nil, type: FolderBaseTypeField = FolderBaseTypeField.folder, sequenceId: String? = nil, name: String? = nil) {
        self.sequenceId = sequenceId
        self.name = name

        super.init(id: id, etag: etag, type: type)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sequenceId = try container.decodeIfPresent(String.self, forKey: .sequenceId)
        name = try container.decodeIfPresent(String.self, forKey: .name)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(sequenceId, forKey: .sequenceId)
        try container.encodeIfPresent(name, forKey: .name)
        try super.encode(to: encoder)
    }

}
