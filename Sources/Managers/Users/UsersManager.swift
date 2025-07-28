import Foundation

public class UsersManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Returns a list of all users for the Enterprise along with their `user_id`,
    /// `public_name`, and `login`.
    /// 
    /// The application and the authenticated user need to
    /// have the permission to look up users in the entire
    /// enterprise.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getUsers method
    ///   - headers: Headers of getUsers method
    /// - Returns: The `Users`.
    /// - Throws: The `GeneralError`.
    public func getUsers(queryParams: GetUsersQueryParams = GetUsersQueryParams(), headers: GetUsersHeaders = GetUsersHeaders()) async throws -> Users {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["filter_term": Utils.Strings.toString(value: queryParams.filterTerm), "user_type": Utils.Strings.toString(value: queryParams.userType), "external_app_user_id": Utils.Strings.toString(value: queryParams.externalAppUserId), "fields": Utils.Strings.toString(value: queryParams.fields), "offset": Utils.Strings.toString(value: queryParams.offset), "limit": Utils.Strings.toString(value: queryParams.limit), "usemarker": Utils.Strings.toString(value: queryParams.usemarker), "marker": Utils.Strings.toString(value: queryParams.marker)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/users")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try Users.deserialize(from: response.data!)
    }

    /// Creates a new managed user in an enterprise. This endpoint
    /// is only available to users and applications with the right
    /// admin permissions.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createUser method
    ///   - queryParams: Query parameters of createUser method
    ///   - headers: Headers of createUser method
    /// - Returns: The `UserFull`.
    /// - Throws: The `GeneralError`.
    public func createUser(requestBody: CreateUserRequestBody, queryParams: CreateUserQueryParams = CreateUserQueryParams(), headers: CreateUserHeaders = CreateUserHeaders()) async throws -> UserFull {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/users")", method: "POST", params: queryParamsMap, headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try UserFull.deserialize(from: response.data!)
    }

    /// Retrieves information about the user who is currently authenticated.
    /// 
    /// In the case of a client-side authenticated OAuth 2.0 application
    /// this will be the user who authorized the app.
    /// 
    /// In the case of a JWT, server-side authenticated application
    /// this will be the service account that belongs to the application
    /// by default.
    /// 
    /// Use the `As-User` header to change who this API call is made on behalf of.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getUserMe method
    ///   - headers: Headers of getUserMe method
    /// - Returns: The `UserFull`.
    /// - Throws: The `GeneralError`.
    public func getUserMe(queryParams: GetUserMeQueryParams = GetUserMeQueryParams(), headers: GetUserMeHeaders = GetUserMeHeaders()) async throws -> UserFull {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/users/me")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try UserFull.deserialize(from: response.data!)
    }

    /// Retrieves information about a user in the enterprise.
    /// 
    /// The application and the authenticated user need to
    /// have the permission to look up users in the entire
    /// enterprise.
    /// 
    /// This endpoint also returns a limited set of information
    /// for external users who are collaborated on content
    /// owned by the enterprise for authenticated users with the
    /// right scopes. In this case, disallowed fields will return
    /// null instead.
    ///
    /// - Parameters:
    ///   - userId: The ID of the user.
    ///     Example: "12345"
    ///   - queryParams: Query parameters of getUserById method
    ///   - headers: Headers of getUserById method
    /// - Returns: The `UserFull`.
    /// - Throws: The `GeneralError`.
    public func getUserById(userId: String, queryParams: GetUserByIdQueryParams = GetUserByIdQueryParams(), headers: GetUserByIdHeaders = GetUserByIdHeaders()) async throws -> UserFull {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/users/")\(userId)", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try UserFull.deserialize(from: response.data!)
    }

    /// Updates a managed or app user in an enterprise. This endpoint
    /// is only available to users and applications with the right
    /// admin permissions.
    ///
    /// - Parameters:
    ///   - userId: The ID of the user.
    ///     Example: "12345"
    ///   - requestBody: Request body of updateUserById method
    ///   - queryParams: Query parameters of updateUserById method
    ///   - headers: Headers of updateUserById method
    /// - Returns: The `UserFull`.
    /// - Throws: The `GeneralError`.
    public func updateUserById(userId: String, requestBody: UpdateUserByIdRequestBody = UpdateUserByIdRequestBody(), queryParams: UpdateUserByIdQueryParams = UpdateUserByIdQueryParams(), headers: UpdateUserByIdHeaders = UpdateUserByIdHeaders()) async throws -> UserFull {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/users/")\(userId)", method: "PUT", params: queryParamsMap, headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try UserFull.deserialize(from: response.data!)
    }

    /// Deletes a user. By default this will fail if the user
    /// still owns any content. Move their owned content first
    /// before proceeding, or use the `force` field to delete
    /// the user and their files.
    ///
    /// - Parameters:
    ///   - userId: The ID of the user.
    ///     Example: "12345"
    ///   - queryParams: Query parameters of deleteUserById method
    ///   - headers: Headers of deleteUserById method
    /// - Throws: The `GeneralError`.
    public func deleteUserById(userId: String, queryParams: DeleteUserByIdQueryParams = DeleteUserByIdQueryParams(), headers: DeleteUserByIdHeaders = DeleteUserByIdHeaders()) async throws {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["notify": Utils.Strings.toString(value: queryParams.notify), "force": Utils.Strings.toString(value: queryParams.force)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/users/")\(userId)", method: "DELETE", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

}
