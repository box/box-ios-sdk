import Foundation
import os

/// Provides communication with Box APIs. Defines methods for communication with Box APIs
public class BoxClient {
    /// Provides [File](../Structs/File.html) management.
    public private(set) lazy var files = FilesModule(boxClient: self)
    /// Provides [Folder](../Structs/Folder.html) management.
    public private(set) lazy var folders = FoldersModule(boxClient: self)
    /// Provides [User](../Structs/User.html) management.
    public private(set) lazy var users = UsersModule(boxClient: self)
    /// Provides [Group](../Structs/Group.html) management.
    public private(set) lazy var groups = GroupsModule(boxClient: self)
    /// Provides [Comment](../Structs/Comment.html) management.
    public private(set) lazy var comments = CommentsModule(boxClient: self)
    /// Provides [SharedItem](../Structs/SharedItem.html) management.
    public private(set) lazy var sharedItems = SharedItemsModule(boxClient: self)
    /// Web Links management.
    public private(set) lazy var webLinks = WebLinksModule(boxClient: self)
    /// Provides search functionality.
    public private(set) lazy var search = SearchModule(boxClient: self)
    /// Provides collections functionality.
    public private(set) lazy var collections = CollectionsModule(boxClient: self)
    /// Provides collaborations functionality.
    public private(set) lazy var collaborations = CollaborationsModule(boxClient: self)
    /// Provides collaborations whitelist functionality.
    public private(set) lazy var collaborationWhiteList = CollaborationWhitelistModule(boxClient: self)
    /// Metadata management.
    public private(set) lazy var metadata = MetadataModule(boxClient: self)
    /// Provides [Events](../Structs/Events.html) management.
    public private(set) lazy var events = EventsModule(boxClient: self)
    /// Metadata cascade policy.
    public private(set) lazy var metadataCascadePolicy = MetadataCascadePolicyModule(boxClient: self)
    /// Trash management.
    public private(set) lazy var trash = TrashModule(boxClient: self)
    /// Device Pin management.
    public private(set) lazy var devicePins = DevicePinsModule(boxClient: self)
    /// Recent Items management
    public private(set) lazy var recentItems = RecentItemsModule(boxClient: self)
    /// Webhooks management
    public private(set) lazy var webhooks = WebhooksModule(boxClient: self)
    /// Tasks management.
    public private(set) lazy var tasks = TasksModule(boxClient: self)
    /// Retention policy management.
    public private(set) lazy var retentionPolicy = RetentionPoliciesModule(boxClient: self)
    /// Provides [TermsOfService](../Structs/TermsOfService.html)
    public private(set) lazy var termsOfService = TermsOfServicesModule(boxClient: self)
    /// Legal Hold Policies management
    public private(set) lazy var legalHolds = LegalHoldsModule(boxClient: self)
    /// Storage Policies management
    public private(set) lazy var storagePolicies = StoragePoliciesModule(boxClient: self)

    /// Provides network communication with the Box APIs.
    private var networkAgent: NetworkAgentProtocol
    /// Provides authentication session management.
    public private(set) var session: SessionProtocol
    /// Requests header.
    public private(set) var headers: BoxHTTPHeaders? = [:]
    /// SDK request configuration.
    public private(set) var configuration: BoxSDKConfiguration
    /// Indicates whether this BoxClient instance has been destroyed
    public private(set) var isDestroyed: Bool
    /// ID of user's favorites collection.
    public internal(set) var favoritesCollectionId: String?

    /// Initializer
    ///
    /// - Parameters:
    ///   - networkAgent: Provides network communication with the Box APIs.
    ///   - session: Provides authentication session management.
    ///   - configuration: Provides parameters to makes API calls in order to tailor it to their application's specific needs
    public init(networkAgent: NetworkAgentProtocol, session: SessionProtocol, configuration: BoxSDKConfiguration) {
        self.networkAgent = networkAgent
        self.session = session
        self.configuration = configuration
        isDestroyed = false
    }

    /// Creates BoxClient instance based on shared link URL and password.
    ///
    /// - Parameters:
    ///   - url: Shared link URL.
    ///   - password: Shared link password.
    /// - Returns: Returns new standard BoxClient object.
    public func withSharedLink(url: URL, password: String?) -> BoxClient {
        let networkAgent = BoxNetworkAgent(configuration: configuration)
        let client = BoxClient(networkAgent: networkAgent, session: session, configuration: configuration)
        client.addSharedLinkHeader(sharedLink: url, sharedLinkPassword: password)
        return client
    }

    /// Creates BoxClient instance based on user identifier.
    ///
    /// - Parameter userId: User identifier.
    /// - Returns: Returns new standard BoxCliennt object.
    public func asUser(withId userId: String) -> BoxClient {
        let networkAgent = BoxNetworkAgent(configuration: configuration)
        let client = BoxClient(networkAgent: networkAgent, session: session, configuration: configuration)
        client.addAsUserHeader(userId: userId)
        return client
    }

    /// Destroys the client, revoking its access tokens and rendering it inoperable.
    ///
    /// - Parameter completion: Called when the operation is complete.
    public func destroy(completion: @escaping Callback<Void>) {
        session.revokeTokens(completion: { result in

            switch result {
            case let .failure(error):
                completion(.failure(error))
            case .success:
                self.isDestroyed = true
                completion(.success(()))
            }
        })
    }

    /// Exchange the token.
    ///
    /// - Parameters:
    ///   - scope: Scope or scopes that you want to apply to the resulting token.
    ///   - resource: Full url path to the file that the token should be generated for, eg: https://api.box.com/2.0/files/{file_id}
    ///   - sharedLink: Shared link to get a token for.
    ///   - completion: Returns the success or an error.
    public func exchangeToken(
        scope: Set<TokenScope>,
        resource: String? = nil,
        sharedLink: String? = nil,
        completion: @escaping TokenInfoClosure
    ) {
        session.downscopeToken(scope: scope, resource: resource, sharedLink: sharedLink, completion: completion)
    }
}

private extension BoxClient {
    func send(
        request: BoxRequest,
        completion: @escaping Callback<BoxResponse>
    ) {
        guard !isDestroyed else {
            completion(.failure(BoxSDKError(message: .clientDestroyed)))
            return
        }
        session.getAccessToken { (result: Result<String, BoxSDKError>) in

            switch result {
            case let .failure(error):
                completion(.failure(error))
                return

            case let .success(token):
                let updatedRequest = request
                updatedRequest.httpHeaders["Authorization"] = "Bearer \(token)"
                updatedRequest.addBoxAPIRelatedHeaders(self.headers)

                self.networkAgent.send(
                    request: updatedRequest,
                    completion: { [weak self] (result: Result<BoxResponse, BoxSDKError>) in
                        self?.handleAuthIssues(
                            result: result,
                            completion: completion
                        )
                    }
                )
            }
        }
    }

    func handleAuthIssues(
        result: Result<BoxResponse, BoxSDKError>,
        completion: @escaping Callback<BoxResponse>
    ) {
        switch result {
        case let .success(resultObj):
            completion(.success(resultObj))
        case let .failure(error):
            if let apiError = error as? BoxAPIAuthError, apiError.message == .unauthorizedAccess {
                if let tokenHandlingSession = session as? ExpiredTokenHandling {
                    tokenHandlingSession.handleExpiredToken(completion: { _ in completion(.failure(error)) })
                    return
                }
            }
            completion(.failure(error))
        }
    }

    func addSharedLinkHeader(sharedLink: URL, sharedLinkPassword: String?) {
        if let sharedLinkPassword = sharedLinkPassword {
            headers?[BoxHTTPHeaderKey.boxApi] = "\(BoxAPIHeaderKey.sharedLink)=\(sharedLink.absoluteString)&\(BoxAPIHeaderKey.sharedLinkPassword)=\(sharedLinkPassword)"
        }
        else {
            headers?[BoxHTTPHeaderKey.boxApi] = "\(BoxAPIHeaderKey.sharedLink)=\(sharedLink.absoluteString)"
        }
    }

    func addAsUserHeader(userId: String) {
        headers?[BoxHTTPHeaderKey.asUser] = userId
    }
}

// MARK: - BoxClientProtocol methods

extension BoxClient: BoxClientProtocol {

    /// Performs an HTTP GET method call on an API endpoint and returns a response.
    ///
    /// - Parameters:
    ///   - url: The URL of the API endpoint to call.
    ///   - httpHeaders: Additional information to be passed in the HTTP headers of the request.
    ///   - queryParameters: Additional parameters to be passed in the URL that is called.
    ///   - completion: Returns a BoxResponse object or an error if request fails
    public func get(
        url: URL,
        httpHeaders: BoxHTTPHeaders = [:],
        queryParameters: QueryParameters = [:],
        completion: @escaping Callback<BoxResponse>
    ) {
        send(
            request: BoxRequest(
                httpMethod: .get,
                url: url,
                httpHeaders: httpHeaders,
                queryParams: queryParameters,
                body: .empty
            ),
            completion: completion
        )
    }

    /// Performs an HTTP POST method call on an API endpoint and returns a response.
    ///
    /// - Parameters:
    ///   - url: The URL of the API endpoint to call.
    ///   - httpHeaders: Additional information to be passed in the HTTP headers of the request.
    ///   - queryParameters: Additional parameters to be passed in the URL that is called.
    ///   - json: The JSON body of the request
    ///   - completion: Returns a BoxResponse object or an error if request fails
    public func post(
        url: URL,
        httpHeaders: BoxHTTPHeaders = [:],
        queryParameters: QueryParameters = [:],
        json: Any? = nil,
        completion: @escaping Callback<BoxResponse>
    ) {
        send(
            request: BoxRequest(
                httpMethod: .post,
                url: url,
                httpHeaders: httpHeaders,
                queryParams: queryParameters,
                body: jsonToBody(json)
            ),
            completion: completion
        )
    }

    /// Performs an HTTP POST method call on an API endpoint and returns a response.
    ///
    /// - Parameters:
    ///   - url: The URL of the API endpoint to call.
    ///   - httpHeaders: Additional information to be passed in the HTTP headers of the request.
    ///   - queryParameters: Additional parameters to be passed in the URL that is called.
    ///   - multipartBody: The multipart body of the request
    ///   - completion: Returns a BoxResponse object or an error if request fails
    /// - Returns: BoxUploadTask
    @discardableResult
    public func post(
        url: URL,
        httpHeaders: BoxHTTPHeaders = [:],
        queryParameters: QueryParameters = [:],
        multipartBody: MultipartForm,
        progress: @escaping (Progress) -> Void = { _ in },
        completion: @escaping Callback<BoxResponse>
    ) -> BoxUploadTask {
        let task = BoxUploadTask()
        send(
            request: BoxRequest(
                httpMethod: .post,
                url: url,
                httpHeaders: httpHeaders,
                queryParams: queryParameters,
                body: .multipart(multipartBody),
                task: task.receiveTask,
                progress: progress
            ),
            completion: completion
        )
        return task
    }

    /// Performs an HTTP PUT method call on an API endpoint and returns a response.
    ///
    /// - Parameters:
    ///   - url: The URL of the API endpoint to call.
    ///   - httpHeaders: Additional information to be passed in the HTTP headers of the request.
    ///   - queryParameters: Additional parameters to be passed in the URL that is called.
    ///   - json: The JSON body of the request
    ///   - completion: Returns a BoxResponse object or an error if request fails
    public func put(
        url: URL,
        httpHeaders: BoxHTTPHeaders = [:],
        queryParameters: QueryParameters = [:],
        json: Any? = nil,
        completion: @escaping Callback<BoxResponse>
    ) {
        send(
            request: BoxRequest(
                httpMethod: .put,
                url: url,
                httpHeaders: httpHeaders,
                queryParams: queryParameters,
                body: jsonToBody(json)
            ),
            completion: completion
        )
    }

    /// Performs an HTTP PUT method call on an API endpoint and returns a response.
    ///
    /// - Parameters:
    ///   - url: The URL of the API endpoint to call.
    ///   - httpHeaders: Additional information to be passed in the HTTP headers of the request.
    ///   - queryParameters: Additional parameters to be passed in the URL that is called.
    ///   - multipartBody: The multipart body of the request
    ///   - completion: Returns a BoxResponse object or an error if request fails
    /// - Returns: BoxUploadTask
    @discardableResult
    public func put(
        url: URL,
        httpHeaders: BoxHTTPHeaders = [:],
        queryParameters: QueryParameters = [:],
        multipartBody: MultipartForm,
        progress: @escaping (Progress) -> Void = { _ in },
        completion: @escaping Callback<BoxResponse>
    ) -> BoxUploadTask {
        let task = BoxUploadTask()
        send(
            request: BoxRequest(
                httpMethod: .put,
                url: url,
                httpHeaders: httpHeaders,
                queryParams: queryParameters,
                body: .multipart(multipartBody),
                task: task.receiveTask,
                progress: progress
            ),
            completion: completion
        )
        return task
    }

    /// Performs an HTTP PUT method call on an API endpoint and returns a response - variant for chunked upload.
    ///
    /// - Parameters:
    ///   - url: The URL of the API endpoint to call.
    ///   - httpHeaders: Additional information to be passed in the HTTP headers of the request.
    ///   - queryParameters: Additional parameters to be passed in the URL that is called.
    ///   - data: Binary body of the request
    ///   - progress: Closure where upload progress will be reported
    ///   - completion: Returns a BoxResponse object or an error if request fails
    /// - Returns: BoxUploadTask
    @discardableResult
    public func put(
        url: URL,
        httpHeaders: BoxHTTPHeaders = [:],
        queryParameters: QueryParameters = [:],
        data: Data,
        progress: @escaping (Progress) -> Void = { _ in },
        completion: @escaping Callback<BoxResponse>
    ) -> BoxUploadTask {
        let task = BoxUploadTask()
        send(
            request: BoxRequest(
                httpMethod: .put,
                url: url,
                httpHeaders: httpHeaders,
                queryParams: queryParameters,
                body: .data(data),
                task: task.receiveTask,
                progress: progress
            ),
            completion: completion
        )
        return task
    }

    /// Performs an HTTP OPTIONS method call on an API endpoint and returns a response.
    ///
    /// - Parameters:
    ///   - url: The URL of the API endpoint to call.
    ///   - httpHeaders: Additional information to be passed in the HTTP headers of the request.
    ///   - queryParameters: Additional parameters to be passed in the URL that is called.
    ///   - json: The JSON body of the request
    ///   - completion: Returns a BoxResponse object or an error if request fails
    /// - Returns: BoxNetworkTask
    @discardableResult
    public func options(
        url: URL,
        httpHeaders: BoxHTTPHeaders = [:],
        queryParameters: QueryParameters = [:],
        json: Any? = nil,
        completion: @escaping Callback<BoxResponse>
    ) -> BoxNetworkTask {
        let task = BoxNetworkTask()
        send(
            request: BoxRequest(
                httpMethod: .options,
                url: url,
                httpHeaders: httpHeaders,
                queryParams: queryParameters,
                body: jsonToBody(json),
                task: task.receiveTask
            ),
            completion: completion
        )
        return task
    }

    /// Performs an HTTP DELETE method call on an API endpoint and returns a response.
    ///
    /// - Parameters:
    ///   - url: The URL of the API endpoint to call.
    ///   - httpHeaders: Additional information to be passed in the HTTP headers of the request.
    ///   - queryParameters: Additional parameters to be passed in the URL that is called.
    ///   - completion: Returns a BoxResponse object or an error if request fails
    public func delete(
        url: URL,
        httpHeaders: BoxHTTPHeaders = [:],
        queryParameters: QueryParameters = [:],
        completion: @escaping Callback<BoxResponse>
    ) {
        send(
            request: BoxRequest(
                httpMethod: .delete,
                url: url,
                httpHeaders: httpHeaders,
                queryParams: queryParameters,
                body: .empty
            ),
            completion: completion
        )
    }

    /// Performs an HTTP GET method call for downloading on an API endpoint and returns a response.
    ///
    /// - Parameters:
    ///   - url: The URL of the API endpoint to call.
    ///   - httpHeaders: Additional information to be passed in the HTTP headers of the request.
    ///   - queryParameters: Additional parameters to be passed in the URL that is called.
    ///   - downloadDestinationURL: The URL on disk where the data will be saved
    ///   - progress: Completion block to track the progress of the request
    ///   - completion: Returns a BoxResponse object or an error if request fails
    /// - Returns: BoxDownloadTask
    @discardableResult
    public func download(
        url: URL,
        downloadDestinationURL: URL,
        httpHeaders: BoxHTTPHeaders = [:],
        queryParameters: QueryParameters = [:],
        progress: @escaping (Progress) -> Void = { _ in },
        completion: @escaping Callback<BoxResponse>
    ) -> BoxDownloadTask {
        let task = BoxDownloadTask()
        send(
            request: BoxRequest(
                httpMethod: .get,
                url: url,
                httpHeaders: httpHeaders,
                queryParams: queryParameters,
                downloadDestination: downloadDestinationURL,
                task: task.receiveTask,
                progress: progress
            ),
            completion: completion
        )
        return task
    }
}

private extension BoxClient {
    func jsonToBody(_ json: Any?) -> BoxRequest.BodyType {
        if let jsonObject = json as? [String: Any] {
            return .jsonObject(jsonObject)
        }

        if let jsonArray = json as? [[String: Any]] {
            return .jsonArray(jsonArray)
        }

        return .empty
    }
}
