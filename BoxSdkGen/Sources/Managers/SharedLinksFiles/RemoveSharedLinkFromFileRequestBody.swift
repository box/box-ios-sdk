import Foundation

public class RemoveSharedLinkFromFileRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case sharedLink = "shared_link"
    }

    /// By setting this value to `null`, the shared link
    /// is removed from the file.
    @CodableTriState public private(set) var sharedLink: RemoveSharedLinkFromFileRequestBodySharedLinkField?

    /// Initializer for a RemoveSharedLinkFromFileRequestBody.
    ///
    /// - Parameters:
    ///   - sharedLink: By setting this value to `null`, the shared link
    ///     is removed from the file.
    public init(sharedLink: TriStateField<RemoveSharedLinkFromFileRequestBodySharedLinkField> = nil) {
        self._sharedLink = CodableTriState(state: sharedLink)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sharedLink = try container.decodeIfPresent(RemoveSharedLinkFromFileRequestBodySharedLinkField.self, forKey: .sharedLink)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(field: _sharedLink.state, forKey: .sharedLink)
    }

}
