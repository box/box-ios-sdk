import Foundation

public class DownloadsManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Returns the contents of a file in binary format.
    ///
    /// - Parameters:
    ///   - fileId: The unique identifier that represents a file.
    ///     
    ///     The ID for any file can be determined
    ///     by visiting a file in the web application
    ///     and copying the ID from the URL. For example,
    ///     for the URL `https://*.app.box.com/files/123`
    ///     the `file_id` is `123`.
    ///     Example: "12345"
    ///   - downloadDestinationUrl: The URL on disk where the file will be saved once it has been downloaded.
    ///   - queryParams: Query parameters of downloadFile method
    ///   - headers: Headers of downloadFile method
    /// - Returns: The `URL?`.
    /// - Throws: The `GeneralError`.
    public func downloadFile(fileId: String, downloadDestinationUrl: URL, queryParams: DownloadFileQueryParams = DownloadFileQueryParams(), headers: DownloadFileHeaders = DownloadFileHeaders()) async throws -> URL? {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["version": Utils.Strings.toString(value: queryParams.version), "access_token": Utils.Strings.toString(value: queryParams.accessToken)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["range": Utils.Strings.toString(value: headers.range), "boxapi": Utils.Strings.toString(value: headers.boxapi)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/files/")\(fileId)\("/content")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.binary, downloadDestinationUrl: downloadDestinationUrl, auth: self.auth, networkSession: self.networkSession))
        if Utils.Strings.toString(value: response.status) == "202" {
            return nil
        }

        return response.downloadDestinationUrl!
    }

}
