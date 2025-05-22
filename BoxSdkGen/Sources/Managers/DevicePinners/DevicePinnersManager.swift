import Foundation

public class DevicePinnersManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Retrieves information about an individual device pin.
    ///
    /// - Parameters:
    ///   - devicePinnerId: The ID of the device pin
    ///     Example: "2324234"
    ///   - headers: Headers of getDevicePinnerById method
    /// - Returns: The `DevicePinner`.
    /// - Throws: The `GeneralError`.
    public func getDevicePinnerById(devicePinnerId: String, headers: GetDevicePinnerByIdHeaders = GetDevicePinnerByIdHeaders()) async throws -> DevicePinner {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/device_pinners/")\(devicePinnerId)", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try DevicePinner.deserialize(from: response.data!)
    }

    /// Deletes an individual device pin.
    ///
    /// - Parameters:
    ///   - devicePinnerId: The ID of the device pin
    ///     Example: "2324234"
    ///   - headers: Headers of deleteDevicePinnerById method
    /// - Throws: The `GeneralError`.
    public func deleteDevicePinnerById(devicePinnerId: String, headers: DeleteDevicePinnerByIdHeaders = DeleteDevicePinnerByIdHeaders()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/device_pinners/")\(devicePinnerId)", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

    /// Retrieves all the device pins within an enterprise.
    /// 
    /// The user must have admin privileges, and the application
    /// needs the "manage enterprise" scope to make this call.
    ///
    /// - Parameters:
    ///   - enterpriseId: The ID of the enterprise
    ///     Example: "3442311"
    ///   - queryParams: Query parameters of getEnterpriseDevicePinners method
    ///   - headers: Headers of getEnterpriseDevicePinners method
    /// - Returns: The `DevicePinners`.
    /// - Throws: The `GeneralError`.
    public func getEnterpriseDevicePinners(enterpriseId: String, queryParams: GetEnterpriseDevicePinnersQueryParams = GetEnterpriseDevicePinnersQueryParams(), headers: GetEnterpriseDevicePinnersHeaders = GetEnterpriseDevicePinnersHeaders()) async throws -> DevicePinners {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit), "direction": Utils.Strings.toString(value: queryParams.direction)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/enterprises/")\(enterpriseId)\("/device_pinners")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try DevicePinners.deserialize(from: response.data!)
    }

}
