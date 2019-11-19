//
//  BoxSDKConfiguration.swift
//  BoxSDK
//
//  Created by Abel Osorio on 4/22/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// The default base factor used in calculating exponential backoff delay for retries
private let defaultRetryBaseInterval: TimeInterval = 1

/// The number of times a failing request will be retried
private let defaultMaxRetryAttempts = 5

/// Refresh token 1 min before expiration
private let defaultTokenRefreshThreshold: TimeInterval = 60

// swiftlint:disable force_unwrapping

/// Default value of request base URL
private let defaultAPIBaseURL = URL(string: "https://api.box.com")!

/// Default value of upload request base URL
private let defaultUploadAPIBaseURL = URL(string: "https://upload.box.com")!

private let defaultOAuth2AuthorizeURL = URL(string: "https://account.box.com/api/oauth2/authorize")!

// swiftlint:enable force_unwrapping

/// SDK configuration specifying request related information
public struct BoxSDKConfiguration {

    /// The client ID of the application requesting authentication. To get the client ID for your application,
    /// log in to your Box developer console and click the Edit Application link for the application you're working with.
    /// In the OAuth 2 Parameters section of the configuration page, find the item labeled "client_id".
    /// The text of that item is your application's client ID.
    public let clientId: String
    /// The client secret of the application requesting authentication. To get the client secret for your application,
    /// log in to your Box developer console and click the Edit Application link for the application you're working with.
    /// In the OAuth 2 Parameters section of the configuration page, find the item labeled "client_secret". The text of that item is your application's client secret.
    public let clientSecret: String
    /// Base URL for majority of the requests.
    public let apiBaseURL: URL
    /// Base URL for file upload requests.
    public let uploadApiBaseURL: URL
    /// URL for the OAuth2 authorization page, where users are redirected to enter their credentials
    public let oauth2AuthorizeURL: URL
    /// Maximum number of retries for a failed request.
    public let maxRetryAttempts: Int
    /// Specifies how long before token expiration date it should be refreshed.
    public let tokenRefreshThreshold: TimeInterval
    /// The base factor used in calculating exponential backoff delay for retries
    public let retryBaseInterval: TimeInterval
    /// Analytics info that is set to request headers.
    public let clientAnalyticsInfo: ClientAnalyticsInfo?
    /// Console log destination.
    public let consoleLogDestination: ConsoleLogDestination
    /// File log destination.
    public let fileLogDestination: FileLogDestination?

    /// Initializer
    ///
    /// - Parameters:
    ///   - clientId: The client ID of the application requesting authentication.
    ///   - clientSecret: The client secret of the application requesting authentication.
    ///   - apiBaseURL: Base URL for majority of the requests.
    ///   - uploadApiBaseURL: Base URL for upload requests
    ///   - maxRetryAttempts: Base URL for file upload requests.
    ///   - tokenRefreshThreshold: Specifies how long before token expiration date it should be refreshed.
    ///   - retryBaseInterval: The base factor used in calculating exponential backoff delay for retries
    ///   - consoleLogDestination: Console log destination.
    ///   - fileLogDestination: File log destination.
    ///   - clientAnalyticsInfo: Analytics info that is set to request headers.
    init(
        clientId: String = "",
        clientSecret: String = "",
        apiBaseURL: URL? = defaultAPIBaseURL,
        uploadApiBaseURL: URL? = defaultUploadAPIBaseURL,
        oauth2AuthorizeURL: URL? = defaultOAuth2AuthorizeURL,
        maxRetryAttempts: Int? = defaultMaxRetryAttempts,
        tokenRefreshThreshold: TimeInterval? = defaultTokenRefreshThreshold,
        retryBaseInterval: TimeInterval? = defaultRetryBaseInterval,
        consoleLogDestination: ConsoleLogDestination? = ConsoleLogDestination(),
        fileLogDestination: FileLogDestination? = nil,
        clientAnalyticsInfo: ClientAnalyticsInfo? = nil
    ) throws {
        self.clientId = clientId
        self.clientSecret = clientSecret

        self.apiBaseURL = apiBaseURL ?? defaultAPIBaseURL
        self.uploadApiBaseURL = uploadApiBaseURL ?? defaultUploadAPIBaseURL
        self.oauth2AuthorizeURL = oauth2AuthorizeURL ?? defaultOAuth2AuthorizeURL

        try URLValidation.validate(networkUrl: self.apiBaseURL)
        try URLValidation.validate(networkUrl: self.uploadApiBaseURL)
        try URLValidation.validate(networkUrl: self.oauth2AuthorizeURL)

        self.maxRetryAttempts = maxRetryAttempts ?? defaultMaxRetryAttempts
        self.tokenRefreshThreshold = tokenRefreshThreshold ?? defaultTokenRefreshThreshold
        self.retryBaseInterval = retryBaseInterval ?? defaultRetryBaseInterval
        self.consoleLogDestination = consoleLogDestination ?? ConsoleLogDestination()
        self.fileLogDestination = fileLogDestination
        self.clientAnalyticsInfo = clientAnalyticsInfo
    }
}
