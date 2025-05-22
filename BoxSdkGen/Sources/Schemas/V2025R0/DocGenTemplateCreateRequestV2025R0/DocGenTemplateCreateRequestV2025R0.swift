import Foundation

/// The schema for marking document as Box Doc Gen template.
public class DocGenTemplateCreateRequestV2025R0: Codable {
    private enum CodingKeys: String, CodingKey {
        case file
    }

    public let file: FileReferenceV2025R0

    public init(file: FileReferenceV2025R0) {
        self.file = file
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        file = try container.decode(FileReferenceV2025R0.self, forKey: .file)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(file, forKey: .file)
    }

}
