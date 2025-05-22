import Foundation

/// Represents a successful request to create a `zip` archive of a list of files
/// and folders.
public class ZipDownload: Codable {
    private enum CodingKeys: String, CodingKey {
        case downloadUrl = "download_url"
        case statusUrl = "status_url"
        case expiresAt = "expires_at"
        case nameConflicts = "name_conflicts"
    }

    /// The URL that can be used to download the `zip` archive. A `Get` request to
    /// this URL will start streaming the items requested. By default, this URL
    /// is only valid for a few seconds, until the `expires_at` time, unless a
    /// download is started after which it is valid for the duration of the
    /// download.
    /// 
    /// It is important to note that the domain and path of this URL might change
    /// between API calls, and therefore it's important to use this URL as-is.
    public let downloadUrl: String?

    /// The URL that can be used to get the status of the `zip` archive being
    /// downloaded. A `Get` request to this URL will return the number of files
    /// in the archive as well as the number of items already downloaded or
    /// skipped. By default, this URL is only valid for a few seconds, until the
    /// `expires_at` time, unless a download is started after which the URL is
    /// valid for 12 hours from the start of the download.
    /// 
    /// It is important to note that the domain and path of this URL might change
    /// between API calls, and therefore it's important to use this URL as-is.
    public let statusUrl: String?

    /// The time and date when this archive will expire. After this time the
    /// `status_url` and `download_url` will return an error.
    /// 
    /// By default, these URLs are only valid for a few seconds, unless a download
    /// is started after which the `download_url` is valid for the duration of the
    /// download, and the `status_url` is valid for 12 hours from the start of the
    /// download.
    public let expiresAt: Date?

    /// A list of conflicts that occurred when trying to create the archive. This
    /// would occur when multiple items have been requested with the
    /// same name.
    /// 
    /// To solve these conflicts, the API will automatically rename an item
    /// and return a mapping between the original item's name and its new
    /// name.
    /// 
    /// For every conflict, both files will be renamed and therefore this list
    /// will always be a multiple of 2.
    public let nameConflicts: [[ZipDownloadNameConflictsField]]?

    /// Initializer for a ZipDownload.
    ///
    /// - Parameters:
    ///   - downloadUrl: The URL that can be used to download the `zip` archive. A `Get` request to
    ///     this URL will start streaming the items requested. By default, this URL
    ///     is only valid for a few seconds, until the `expires_at` time, unless a
    ///     download is started after which it is valid for the duration of the
    ///     download.
    ///     
    ///     It is important to note that the domain and path of this URL might change
    ///     between API calls, and therefore it's important to use this URL as-is.
    ///   - statusUrl: The URL that can be used to get the status of the `zip` archive being
    ///     downloaded. A `Get` request to this URL will return the number of files
    ///     in the archive as well as the number of items already downloaded or
    ///     skipped. By default, this URL is only valid for a few seconds, until the
    ///     `expires_at` time, unless a download is started after which the URL is
    ///     valid for 12 hours from the start of the download.
    ///     
    ///     It is important to note that the domain and path of this URL might change
    ///     between API calls, and therefore it's important to use this URL as-is.
    ///   - expiresAt: The time and date when this archive will expire. After this time the
    ///     `status_url` and `download_url` will return an error.
    ///     
    ///     By default, these URLs are only valid for a few seconds, unless a download
    ///     is started after which the `download_url` is valid for the duration of the
    ///     download, and the `status_url` is valid for 12 hours from the start of the
    ///     download.
    ///   - nameConflicts: A list of conflicts that occurred when trying to create the archive. This
    ///     would occur when multiple items have been requested with the
    ///     same name.
    ///     
    ///     To solve these conflicts, the API will automatically rename an item
    ///     and return a mapping between the original item's name and its new
    ///     name.
    ///     
    ///     For every conflict, both files will be renamed and therefore this list
    ///     will always be a multiple of 2.
    public init(downloadUrl: String? = nil, statusUrl: String? = nil, expiresAt: Date? = nil, nameConflicts: [[ZipDownloadNameConflictsField]]? = nil) {
        self.downloadUrl = downloadUrl
        self.statusUrl = statusUrl
        self.expiresAt = expiresAt
        self.nameConflicts = nameConflicts
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        downloadUrl = try container.decodeIfPresent(String.self, forKey: .downloadUrl)
        statusUrl = try container.decodeIfPresent(String.self, forKey: .statusUrl)
        expiresAt = try container.decodeDateTimeIfPresent(forKey: .expiresAt)
        nameConflicts = try container.decodeIfPresent([[ZipDownloadNameConflictsField]].self, forKey: .nameConflicts)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(downloadUrl, forKey: .downloadUrl)
        try container.encodeIfPresent(statusUrl, forKey: .statusUrl)
        try container.encodeDateTimeIfPresent(field: expiresAt, forKey: .expiresAt)
        try container.encodeIfPresent(nameConflicts, forKey: .nameConflicts)
    }

}
