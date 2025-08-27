import Foundation

public class UploadsManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Update a file's content. For file sizes over 50MB we recommend
    /// using the Chunk Upload APIs.
    /// 
    /// The `attributes` part of the body must come **before** the
    /// `file` part. Requests that do not follow this format when
    /// uploading the file will receive a HTTP `400` error with a
    /// `metadata_after_file_contents` error code.
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
    ///   - requestBody: Request body of uploadFileVersion method
    ///   - queryParams: Query parameters of uploadFileVersion method
    ///   - headers: Headers of uploadFileVersion method
    /// - Returns: The `Files`.
    /// - Throws: The `GeneralError`.
    public func uploadFileVersion(fileId: String, requestBody: UploadFileVersionRequestBody, queryParams: UploadFileVersionQueryParams = UploadFileVersionQueryParams(), headers: UploadFileVersionHeaders = UploadFileVersionHeaders()) async throws -> Files {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["if-match": Utils.Strings.toString(value: headers.ifMatch), "content-md5": Utils.Strings.toString(value: headers.contentMd5)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.uploadUrl)\("/2.0/files/")\(fileId)\("/content")", method: "POST", params: queryParamsMap, headers: headersMap, multipartData: [MultipartItem(partName: "attributes", data: try requestBody.attributes.serialize()), MultipartItem(partName: "file", fileStream: requestBody.file, fileName: requestBody.fileFileName, contentType: requestBody.fileContentType)], contentType: "multipart/form-data", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try Files.deserialize(from: response.data!)
    }

    /// Performs a check to verify that a file will be accepted by Box
    /// before you upload the entire file.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of preflightFileUploadCheck method
    ///   - headers: Headers of preflightFileUploadCheck method
    /// - Returns: The `UploadUrl`.
    /// - Throws: The `GeneralError`.
    public func preflightFileUploadCheck(requestBody: PreflightFileUploadCheckRequestBody = PreflightFileUploadCheckRequestBody(), headers: PreflightFileUploadCheckHeaders = PreflightFileUploadCheckHeaders()) async throws -> UploadUrl {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/files/content")", method: "OPTIONS", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try UploadUrl.deserialize(from: response.data!)
    }

    /// Uploads a small file to Box. For file sizes over 50MB we recommend
    /// using the Chunk Upload APIs.
    /// 
    /// The `attributes` part of the body must come **before** the
    /// `file` part. Requests that do not follow this format when
    /// uploading the file will receive a HTTP `400` error with a
    /// `metadata_after_file_contents` error code.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of uploadFile method
    ///   - queryParams: Query parameters of uploadFile method
    ///   - headers: Headers of uploadFile method
    /// - Returns: The `Files`.
    /// - Throws: The `GeneralError`.
    public func uploadFile(requestBody: UploadFileRequestBody, queryParams: UploadFileQueryParams = UploadFileQueryParams(), headers: UploadFileHeaders = UploadFileHeaders()) async throws -> Files {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["content-md5": Utils.Strings.toString(value: headers.contentMd5)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.uploadUrl)\("/2.0/files/content")", method: "POST", params: queryParamsMap, headers: headersMap, multipartData: [MultipartItem(partName: "attributes", data: try requestBody.attributes.serialize()), MultipartItem(partName: "file", fileStream: requestBody.file, fileName: requestBody.fileFileName, contentType: requestBody.fileContentType)], contentType: "multipart/form-data", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try Files.deserialize(from: response.data!)
    }

    ///  Upload a file with a preflight check
    ///
    /// - Parameters:
    ///   - requestBody: 
    ///   - queryParams: Query parameters of uploadFile method
    ///   - headers: Headers of uploadFile method
    /// - Returns: The `Files`.
    /// - Throws: The `GeneralError`.
    public func uploadWithPreflightCheck(requestBody: UploadWithPreflightCheckRequestBody, queryParams: UploadWithPreflightCheckQueryParams = UploadWithPreflightCheckQueryParams(), headers: UploadWithPreflightCheckHeaders = UploadWithPreflightCheckHeaders()) async throws -> Files {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["content-md5": Utils.Strings.toString(value: headers.contentMd5)], headers.extraHeaders))
        let preflightUploadUrl: UploadUrl = try await self.preflightFileUploadCheck(requestBody: PreflightFileUploadCheckRequestBody(name: requestBody.attributes.name, size: requestBody.attributes.size, parent: PreflightFileUploadCheckRequestBodyParentField(id: requestBody.attributes.parent.id)), headers: PreflightFileUploadCheckHeaders(extraHeaders: headers.extraHeaders))
        if preflightUploadUrl.uploadUrl == nil || !(preflightUploadUrl.uploadUrl!.contains("http")) {
            throw BoxSDKError(message: "Unable to get preflight upload URL")
        }

        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: preflightUploadUrl.uploadUrl!, method: "POST", params: queryParamsMap, headers: headersMap, multipartData: [MultipartItem(partName: "attributes", data: try requestBody.attributes.serialize()), MultipartItem(partName: "file", fileStream: requestBody.file, fileName: requestBody.fileFileName, contentType: requestBody.fileContentType)], contentType: "multipart/form-data", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try Files.deserialize(from: response.data!)
    }

}
