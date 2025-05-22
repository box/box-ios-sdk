import Foundation

public class UpdateFileVersionByIdRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case trashedAt = "trashed_at"
    }

    /// Set this to `null` to clear
    /// the date and restore the file.
    @CodableTriState public private(set) var trashedAt: String?

    /// Initializer for a UpdateFileVersionByIdRequestBody.
    ///
    /// - Parameters:
    ///   - trashedAt: Set this to `null` to clear
    ///     the date and restore the file.
    public init(trashedAt: TriStateField<String> = nil) {
        self._trashedAt = CodableTriState(state: trashedAt)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        trashedAt = try container.decodeIfPresent(String.self, forKey: .trashedAt)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(field: _trashedAt.state, forKey: .trashedAt)
    }

}
