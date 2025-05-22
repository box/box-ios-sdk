import Foundation

public class CreateFileUploadSessionCommitRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case parts
    }

    /// The list details for the uploaded parts
    public let parts: [UploadPart]

    /// Initializer for a CreateFileUploadSessionCommitRequestBody.
    ///
    /// - Parameters:
    ///   - parts: The list details for the uploaded parts
    public init(parts: [UploadPart]) {
        self.parts = parts
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        parts = try container.decode([UploadPart].self, forKey: .parts)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(parts, forKey: .parts)
    }

}
