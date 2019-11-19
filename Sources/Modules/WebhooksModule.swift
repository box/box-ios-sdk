//
//  WebhooksModule.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 8/29/19.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

/// Provides management of Webhooks
public class WebhooksModule {
    /// Required for communicating with Box APIs.
    weak var boxClient: BoxClient!
    // swiftlint:disable:previous implicitly_unwrapped_optional

    /// Initializer
    ///
    /// - Parameter boxClient: Required for communicating with Box APIs.
    init(boxClient: BoxClient) {
        self.boxClient = boxClient
    }

    /// Get all webhooks in an enterprise.
    ///
    /// - Parameters:
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    public func list(
        marker: String? = nil,
        limit: Int? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<PagingIterator<Webhook>>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/webhooks", configuration: boxClient.configuration),
            queryParameters: [
                "marker": marker,
                "limit": limit,
                "fields": FieldsQueryParam(fields)
            ],
            completion: ResponseHandler.pagingIterator(client: boxClient, wrapping: completion)
        )
    }

    /// Get information about a webhook.
    ///
    /// - Parameters:
    ///   - webhookId: The ID of the webhook on which to retrieve information.
    ///   - fields: String array of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: Returns a Webhook response object if successful otherwise a BoxSDKError.
    public func get(
        webhookId: String,
        fields: [String]? = nil,
        completion: @escaping Callback<Webhook>
    ) {

        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/webhooks/\(webhookId)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Update a webhook
    ///
    /// - Parameters:
    ///   - webhookId: The ID of webhook to update
    ///   - targetType: The type of box item that is associated with the webhook (i.e. file or folder)
    ///   - targetId: The ID of the file or folder that is the target
    ///   - triggers: String array of [triggers]
    ///   - address: The notification URL to which Box sends messages when monitored events occur
    ///   - fields: String array of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response. Any attribute in the full [comment](https://developer.box.com/reference#comment-object) objects can be
    ///     passed in the fields parameter to get specific attributes.
    ///   - completion: Returns a Webhook response object if successful otherwise a BoxSDKError.
    public func update(
        webhookId: String,
        targetType: String? = nil,
        targetId: String? = nil,
        triggers: [Webhook.EventTriggers]? = nil,
        address: String? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<Webhook>
    ) {

        var body: [String: Any] = [
            "target": [
                "type": targetType,
                "id": targetId
            ]
        ]
        body["triggers"] = triggers?.map { $0.description }
        body["address"] = address

        boxClient.put(
            url: URL.boxAPIEndpoint("/2.0/webhooks/\(webhookId)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: body,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Create a webhook
    ///
    /// - Parameters:
    ///   - targetType: The type of box item associated with the webhook (i.e. file or folder)
    ///   - targetId: The ID of the file or folder that is the target
    ///   - triggers: String array of [triggers]
    ///   - address: The notification URL to which Box sends messages when monitored events occur
    ///   - fields: String array of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response. Any attribute in the full [comment](https://developer.box.com/reference#comment-object) objects can be
    ///     passed in the fields parameter to get specific attributes.
    ///   - completion: Returns a Webhook response object if successful otherwise a BoxSDKError.
    public func create(
        targetType: String,
        targetId: String,
        triggers: [Webhook.EventTriggers],
        address: String,
        fields: [String]? = nil,
        completion: @escaping Callback<Webhook>
    ) {

        var body: [String: Any] = [
            "target": [
                "type": targetType,
                "id": targetId
            ]
        ]
        body["triggers"] = triggers.map { $0.description }
        body["address"] = address

        boxClient.post(
            url: URL.boxAPIEndpoint("/2.0/webhooks", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: body,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Deletes a webhook.
    ///
    /// - Parameters:
    ///   - webhookId: The ID of the webhook to delete.
    ///   - completion: Returns Void if the comment is deleted.
    public func delete(
        webhookId: String,
        completion: @escaping Callback<Void>
    ) {
        boxClient.delete(
            url: URL.boxAPIEndpoint("/2.0/webhooks/\(webhookId)", configuration: boxClient.configuration),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }
}
