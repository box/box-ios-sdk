import Foundation

public class ShieldInformationBarrierReportDetailsDetailsField: Codable {
    private enum CodingKeys: String, CodingKey {
        case folderId = "folder_id"
    }

    /// Folder ID for locating this report
    public let folderId: String?

    /// Initializer for a ShieldInformationBarrierReportDetailsDetailsField.
    ///
    /// - Parameters:
    ///   - folderId: Folder ID for locating this report
    public init(folderId: String? = nil) {
        self.folderId = folderId
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        folderId = try container.decodeIfPresent(String.self, forKey: .folderId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(folderId, forKey: .folderId)
    }

}
