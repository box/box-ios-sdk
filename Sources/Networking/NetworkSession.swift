import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// The Networking Session class provides the URLSession object along with a network configuration parameters used in network communication.
open class NetworkSession {

    /// Additional headers, which are appended to each API request
    public let additionalHeaders: [String: String]

    /// Custom base urls
    public let baseUrls: BaseUrls

    /// Additional network settings.
    public let networkSettings: NetworkSettings

    /// Network client
    public let networkClient: NetworkClient

    /// Sensitive data sanitizer
    public let dataSanitizer: DataSanitizer


    /// Initializer
    ///
    /// - Parameters:
    ///   - networkClient: A network client that implements the `NetworkClient` protocol, which is used to perform network requests.
    ///   - additionalHeaders: A dictionary of headers, which are appended to each API request.
    ///   - networkSettings: Additional network settings that allow you to configure things such as retryStrategy, maxRetryAttempts.
    ///   - baseUrls: Custom base urls that are used for API requests.
    ///   - dataSanitizer: Sensitive data sanitizer that is used for logging sensitive data.
    public init(
        networkClient: NetworkClient = BoxNetworkClient(),
        additionalHeaders: [String: String] = [:],
        networkSettings: NetworkSettings = NetworkSettings(),
        baseUrls: BaseUrls = BaseUrls(),
        dataSanitizer: DataSanitizer = DataSanitizer()
    ) {
        self.networkClient = networkClient
        self.additionalHeaders = additionalHeaders
        self.networkSettings = networkSettings
        self.baseUrls = baseUrls
        self.dataSanitizer = dataSanitizer
    }

    /// Generate a fresh network session by duplicating the existing configuration and network parameters,
    /// while also including additional headers to be attached to every API call.
    ///
    /// - Parameters:
    ///   - additionalHeaders: Dictionary of headers, which are appended to each API request
    public func withAdditionalHeaders(additionalHeaders: [String: String]) -> NetworkSession {
        return NetworkSession(networkClient: self.networkClient, additionalHeaders: Utils.Dictionary.merge(self.additionalHeaders, additionalHeaders), networkSettings: self.networkSettings, baseUrls: self.baseUrls, dataSanitizer: self.dataSanitizer)
    }

    /// Generate a fresh network session by duplicating the existing configuration and network parameters,
    /// while also including custom base urls to be used for every API call.
    ///
    /// - Parameters:
    ///   - baseUrls: Custom base urls
    public func withCustomBaseUrls(baseUrls: BaseUrls) -> NetworkSession {
        return NetworkSession(networkClient: self.networkClient, additionalHeaders: self.additionalHeaders, networkSettings: self.networkSettings, baseUrls: baseUrls, dataSanitizer: self.dataSanitizer)
    }

    /// Generate a fresh network session by duplicating the existing configuration and network parameters,
    /// while also including custom network settings to be used for every API call.
    ///
    /// - Parameters:
    ///   - networkSettings: Additional network settings.
    public func withNetworkClient(networkClient: NetworkClient) -> NetworkSession {
        return NetworkSession(networkClient: networkClient, additionalHeaders: self.additionalHeaders, networkSettings: self.networkSettings, baseUrls: self.baseUrls, dataSanitizer: self.dataSanitizer)
    }

    /// Generate a fresh network session by duplicating the existing configuration and network parameters,
    /// while also including sensitive data sanitizer to be used for logging.
    ///
    /// - Parameters:
    ///   - dataSanitizer: Sensitive data sanitizer
    public func withDataSanitizer(dataSanitizer: DataSanitizer) -> NetworkSession {
        return NetworkSession(networkClient: networkClient, additionalHeaders: self.additionalHeaders, networkSettings: self.networkSettings, baseUrls: self.baseUrls, dataSanitizer: dataSanitizer)
    }
}
