import Foundation

public class FileFullRepresentationsEntriesContentField: Codable {
    private enum CodingKeys: String, CodingKey {
        case urlTemplate = "url_template"
    }

    /// The download URL that can be used to fetch the representation.
    /// Make sure to make an authenticated API call to this endpoint.
    /// 
    /// This URL is a template and will require the `{+asset_path}` to
    /// be replaced by a path. In general, for unpaged representations
    /// it can be replaced by an empty string.
    /// 
    /// For paged representations, replace the `{+asset_path}` with the
    /// page to request plus the extension for the file, for example
    /// `1.pdf`.
    /// 
    /// When requesting the download URL the following additional
    /// query params can be passed along.
    /// 
    /// * `set_content_disposition_type` - Sets the
    /// `Content-Disposition` header in the API response with the
    /// specified disposition type of either `inline` or `attachment`.
    /// If not supplied, the `Content-Disposition` header is not
    /// included in the response.
    /// 
    /// * `set_content_disposition_filename` - Allows the application to
    ///   define the representation's file name used in the
    ///   `Content-Disposition` header.  If not defined, the filename
    ///   is derived from the source file name in Box combined with the
    ///   extension of the representation.
    public let urlTemplate: String?

    /// Initializer for a FileFullRepresentationsEntriesContentField.
    ///
    /// - Parameters:
    ///   - urlTemplate: The download URL that can be used to fetch the representation.
    ///     Make sure to make an authenticated API call to this endpoint.
    ///     
    ///     This URL is a template and will require the `{+asset_path}` to
    ///     be replaced by a path. In general, for unpaged representations
    ///     it can be replaced by an empty string.
    ///     
    ///     For paged representations, replace the `{+asset_path}` with the
    ///     page to request plus the extension for the file, for example
    ///     `1.pdf`.
    ///     
    ///     When requesting the download URL the following additional
    ///     query params can be passed along.
    ///     
    ///     * `set_content_disposition_type` - Sets the
    ///     `Content-Disposition` header in the API response with the
    ///     specified disposition type of either `inline` or `attachment`.
    ///     If not supplied, the `Content-Disposition` header is not
    ///     included in the response.
    ///     
    ///     * `set_content_disposition_filename` - Allows the application to
    ///       define the representation's file name used in the
    ///       `Content-Disposition` header.  If not defined, the filename
    ///       is derived from the source file name in Box combined with the
    ///       extension of the representation.
    public init(urlTemplate: String? = nil) {
        self.urlTemplate = urlTemplate
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        urlTemplate = try container.decodeIfPresent(String.self, forKey: .urlTemplate)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(urlTemplate, forKey: .urlTemplate)
    }

}
