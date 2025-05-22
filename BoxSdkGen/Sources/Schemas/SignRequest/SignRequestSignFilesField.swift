import Foundation

public class SignRequestSignFilesField: Codable {
    private enum CodingKeys: String, CodingKey {
        case files
        case isReadyForDownload = "is_ready_for_download"
    }

    public let files: [FileMini]?

    /// Indicates whether the `sign_files` documents are processing
    /// and the PDFs may be out of date. A change to any document
    /// requires processing on all `sign_files`. We
    /// recommended waiting until processing is finished
    /// (and this value is true) before downloading the PDFs.
    public let isReadyForDownload: Bool?

    /// Initializer for a SignRequestSignFilesField.
    ///
    /// - Parameters:
    ///   - files: 
    ///   - isReadyForDownload: Indicates whether the `sign_files` documents are processing
    ///     and the PDFs may be out of date. A change to any document
    ///     requires processing on all `sign_files`. We
    ///     recommended waiting until processing is finished
    ///     (and this value is true) before downloading the PDFs.
    public init(files: [FileMini]? = nil, isReadyForDownload: Bool? = nil) {
        self.files = files
        self.isReadyForDownload = isReadyForDownload
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        files = try container.decodeIfPresent([FileMini].self, forKey: .files)
        isReadyForDownload = try container.decodeIfPresent(Bool.self, forKey: .isReadyForDownload)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(files, forKey: .files)
        try container.encodeIfPresent(isReadyForDownload, forKey: .isReadyForDownload)
    }

}
