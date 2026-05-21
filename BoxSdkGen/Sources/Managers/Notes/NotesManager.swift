import Foundation

public class NotesManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Creates a Box Note (`.boxnote` file) from supported source content. See the `content_format` field for supported formats.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createNoteConvertV2026R0 method
    ///   - headers: Headers of createNoteConvertV2026R0 method
    /// - Returns: The `NotesConvertResponseV2026R0`.
    /// - Throws: The `GeneralError`.
    public func createNoteConvertV2026R0(requestBody: NotesConvertRequestBodyV2026R0, headers: CreateNoteConvertV2026R0Headers = CreateNoteConvertV2026R0Headers()) async throws -> NotesConvertResponseV2026R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/notes/convert")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try NotesConvertResponseV2026R0.deserialize(from: response.data!)
    }

}
