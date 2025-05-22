import Foundation

extension FetchOptions {

    /// Creates a new `FetchOptions` object with an updated file stream.
    ///
    /// - Parameter fileStream: The new input stream for file uploads.
    /// - Returns: A new `FetchOptions` instance with the updated file stream.
    func withFileStream(fileStream: InputStream) -> FetchOptions {
        return FetchOptions(
            url: url,
            method: method,
            params: params,
            headers: headers,
            data: data,
            fileStream: fileStream,
            multipartData: multipartData,
            contentType: contentType,
            responseFormat: responseFormat,
            downloadDestinationUrl: downloadDestinationUrl,
            auth: auth,
            networkSession: networkSession
        )
    }
}
