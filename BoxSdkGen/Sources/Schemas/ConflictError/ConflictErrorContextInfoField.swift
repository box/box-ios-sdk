import Foundation

public class ConflictErrorContextInfoField: Codable {
    private enum CodingKeys: String, CodingKey {
        case conflicts
    }

    /// A list of the file conflicts that caused this error.
    public let conflicts: [FileConflict]?

    /// Initializer for a ConflictErrorContextInfoField.
    ///
    /// - Parameters:
    ///   - conflicts: A list of the file conflicts that caused this error.
    public init(conflicts: [FileConflict]? = nil) {
        self.conflicts = conflicts
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        conflicts = try container.decodeIfPresent([FileConflict].self, forKey: .conflicts)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(conflicts, forKey: .conflicts)
    }

}
