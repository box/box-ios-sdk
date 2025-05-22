import Foundation

/// A base representation of a Box Doc Gen template, used when
/// nested within another resource.
public class DocGenTemplateBaseV2025R0: Codable {
    private enum CodingKeys: String, CodingKey {
        case file
    }

    public let file: FileReferenceV2025R0?

    public init(file: FileReferenceV2025R0? = nil) {
        self.file = file
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        file = try container.decodeIfPresent(FileReferenceV2025R0.self, forKey: .file)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(file, forKey: .file)
    }

}
