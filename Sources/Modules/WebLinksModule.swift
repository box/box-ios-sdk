//
//  WebLinksModule.swift
//  BoxSDK-iOS
//
//  Created by Cary Cheng on 8/3/19.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

/// Provides [Web Link](../Structs/WebLink.html) management.
public class WebLinksModule {

    /// Required for communicating with Box APIs.
    weak var boxClient: BoxClient!
    // swiftlint:disable:previous implicitly_unwrapped_optional

    /// Initializer
    ///
    /// - Parameter boxClient: Required for communicating with Box APIs.
    init(boxClient: BoxClient) {
        self.boxClient = boxClient
    }

    /// Get information about a specified web link.
    ///
    /// - Parameters:
    ///   - webLinkId: The ID of the web link on which to retrieve information.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: Returns a full web link object or an error.
    public func get(
        webLinkId: String,
        fields: [String]? = nil,
        completion: @escaping Callback<WebLink>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/web_links/\(webLinkId)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Creates a new web link with the specified url on the specified item.
    ///
    /// - Parameters:
    ///   - url: The specified url to create the web link for.
    ///   - parentId: The id of the folder item that the web link lives in.
    ///   - name: Optional name value for the created web link. If no name value is specified, defaults to url.
    ///   - description: Optional description value for the created web link.
    ///   - sharedLink: Shared links provide direct, read-only access to files or folder on Box using a URL.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: Returns a full web link object or an error.
    public func create(
        url: String,
        parentId: String,
        name: String? = nil,
        description: String? = nil,
        sharedLink: NullableParameter<SharedLinkData>? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<WebLink>
    ) {

        var body: [String: Any] = [:]

        body["parent"] = ["id": parentId]
        body["url"] = url
        body["name"] = name
        body["description"] = description

        if let unwrappedSharedLink = sharedLink {
            switch unwrappedSharedLink {
            case .null:
                body["shared_link"] = NSNull()
            case let .value(sharedLinkValue):
                body["shared_link"] = sharedLinkValue.bodyDict
            }
        }

        boxClient.post(
            url: URL.boxAPIEndpoint("/2.0/web_links", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: body,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Update the specified web link info.
    ///
    /// - Parameters:
    ///   - webLinkId: The id of the web link to update info for.
    ///   - url: The new url for the web link to update to.
    ///   - parentId: The id of the new parent folder to move the web link.
    ///   - name: The new name for the web link to update to.
    ///   - description: The new description for the web link to update to.
    ///   - sharedLink: Shared links provide direct, read-only access to files or folder on Box using a URL.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: Returns the updated web link object or an error.
    public func update(
        webLinkId: String,
        url: String? = nil,
        parentId: String? = nil,
        name: String? = nil,
        description: String? = nil,
        sharedLink: NullableParameter<SharedLinkData>? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<WebLink>
    ) {
        var body: [String: Any] = [:]
        body["url"] = url
        body["name"] = name
        body["description"] = description

        if let parentId = parentId {
            body["parent"] = ["id": parentId]
        }

        if let unwrappedSharedLink = sharedLink {
            switch unwrappedSharedLink {
            case .null:
                body["shared_link"] = NSNull()
            case let .value(sharedLinkValue):
                body["shared_link"] = sharedLinkValue.bodyDict
            }
        }

        boxClient.put(
            url: URL.boxAPIEndpoint("/2.0/web_links/\(webLinkId)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: body,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Delete a specified web link.
    ///
    /// - Parameters:
    ///   - webLink: The ID of the web link to delete.
    ///   - completion: An empty response will be returned upon successful deletion.
    public func delete(
        webLinkId: String,
        completion: @escaping Callback<Void>
    ) {
        boxClient.delete(
            url: URL.boxAPIEndpoint("/2.0/web_links/\(webLinkId)", configuration: boxClient.configuration),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Gets web link with updated shared link
    ///
    /// - Parameters:
    ///   - webLinkId: The ID of the web link
    ///   - completion: Returns a standard shared link object or an error
    public func getSharedLink(
        forWebLink webLinkId: String,
        completion: @escaping Callback<SharedLink>
    ) {
        get(webLinkId: webLinkId, fields: ["shared_link"]) { result in
            completion(WebLinksModule.unwrapSharedLinkObject(from: result))
        }
    }

    /// Creates or updates shared link for a web link
    ///
    /// - Parameters:
    ///   - webLink: The ID of the web link
    ///   - access: The level of access. If you omit this field then the access level will be set to the default access level specified by the enterprise admin
    ///   - unsharedAt: The date-time that this link will become disabled. This field can only be set by users with paid accounts
    ///   - password: The password required to access the shared link. Set to .null to remove the password
    ///   - canDownload: Whether the shared link allows downloads. Applies to any items in the folder
    ///   - completion: Returns a standard SharedLink object or an error
    public func setSharedLink(
        forWebLink webLinkId: String,
        access: SharedLinkAccess? = nil,
        unsharedAt: NullableParameter<Date>? = nil,
        password: NullableParameter<String>? = nil,
        canDownload: Bool? = nil,
        completion: @escaping Callback<SharedLink>
    ) {
        update(
            webLinkId: webLinkId,
            sharedLink: .value(SharedLinkData(
                access: access,
                password: password,
                unsharedAt: unsharedAt,
                canDownload: canDownload
            )),
            fields: ["shared_link"]
        ) { result in
            completion(WebLinksModule.unwrapSharedLinkObject(from: result))
        }
    }

    /// Removes shared link for a web link
    ///
    /// - Parameters:
    ///   - webLinkId: The ID of the web link
    ///   - completion: Returns an empty response or an error
    public func deleteSharedLink(
        forWebLink webLinkId: String,
        completion: @escaping Callback<Void>
    ) {
        update(webLinkId: webLinkId, sharedLink: .null) { result in
            completion(result.map { _ in })
        }
    }

    /// Unwrap a SharedLink object from web link
    ///
    /// - Parameter result: A standard collection of objects with the web link object or an error
    /// - Returns: Returns a standard SharedLink object or an error
    static func unwrapSharedLinkObject(from result: Result<WebLink, BoxSDKError>) -> Result<SharedLink, BoxSDKError> {
        switch result {
        case let .success(webLink):
            guard let sharedLink = webLink.sharedLink else {
                return .failure(BoxSDKError(message: .notFound("Shared link for web link")))
            }
            return .success(sharedLink)
        case let .failure(error):
            return .failure(error)
        }
    }
}
