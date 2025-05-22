import Foundation

/// A chunk of a file uploaded as part of
/// an upload session, as returned by some endpoints.
public class UploadedPart: Codable {
    private enum CodingKeys: String, CodingKey {
        case part
    }

    public let part: UploadPart?

    public init(part: UploadPart? = nil) {
        self.part = part
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        part = try container.decodeIfPresent(UploadPart.self, forKey: .part)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(part, forKey: .part)
    }

}
