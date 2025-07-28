import Foundation

public class AvatarsManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Retrieves an image of a the user's avatar.
    ///
    /// - Parameters:
    ///   - userId: The ID of the user.
    ///     Example: "12345"
    ///   - downloadDestinationUrl: The URL on disk where the file will be saved once it has been downloaded.
    ///   - headers: Headers of getUserAvatar method
    /// - Returns: The `URL?`.
    /// - Throws: The `GeneralError`.
    public func getUserAvatar(userId: String, downloadDestinationUrl: URL, headers: GetUserAvatarHeaders = GetUserAvatarHeaders()) async throws -> URL? {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/users/")\(userId)\("/avatar")", method: "GET", headers: headersMap, responseFormat: ResponseFormat.binary, downloadDestinationUrl: downloadDestinationUrl, auth: self.auth, networkSession: self.networkSession))
        return response.downloadDestinationUrl!
    }

    /// Adds or updates a user avatar.
    ///
    /// - Parameters:
    ///   - userId: The ID of the user.
    ///     Example: "12345"
    ///   - requestBody: Request body of createUserAvatar method
    ///   - headers: Headers of createUserAvatar method
    /// - Returns: The `UserAvatar`.
    /// - Throws: The `GeneralError`.
    public func createUserAvatar(userId: String, requestBody: CreateUserAvatarRequestBody, headers: CreateUserAvatarHeaders = CreateUserAvatarHeaders()) async throws -> UserAvatar {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/users/")\(userId)\("/avatar")", method: "POST", headers: headersMap, multipartData: [MultipartItem(partName: "pic", fileStream: requestBody.pic, fileName: requestBody.picFileName, contentType: requestBody.picContentType)], contentType: "multipart/form-data", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try UserAvatar.deserialize(from: response.data!)
    }

    /// Removes an existing user avatar.
    /// You cannot reverse this operation.
    ///
    /// - Parameters:
    ///   - userId: The ID of the user.
    ///     Example: "12345"
    ///   - headers: Headers of deleteUserAvatar method
    /// - Throws: The `GeneralError`.
    public func deleteUserAvatar(userId: String, headers: DeleteUserAvatarHeaders = DeleteUserAvatarHeaders()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/users/")\(userId)\("/avatar")", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

}
