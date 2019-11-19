//
//  CommentsModule.swift
//  BoxSDK-iOS
//
//  Created by Cary Cheng on 5/30/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// Provides [Comment](../Structs/Comment.html) management
public class CommentsModule {
    /// Required for communicating with Box APIs.
    weak var boxClient: BoxClient!
    // swiftlint:disable:previous implicitly_unwrapped_optional

    /// Initializer
    ///
    /// - Parameter boxClient: Required for communicating with Box APIs.
    init(boxClient: BoxClient) {
        self.boxClient = boxClient
    }

    /// Get information about a comment.
    ///
    /// - Parameters:
    ///   - commentId: The ID of the comment on which to retrieve information.
    ///   - fields: String array of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response. Any attribute in the full
    ///     [comment](https://developer.box.com/reference#comment-object) objects can be
    ///     passed in the fields parameter to get specific attributes.
    ///   - completion: Returns a Comment response object if successful otherwise a BoxSDKError.
    public func get(
        commentId: String,
        fields: [String]? = nil,
        completion: @escaping Callback<Comment>
    ) {

        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/comments/\(commentId)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Updates the message for a comment.
    ///
    /// - Parameters:
    ///   - commentId: The ID of the comment to update info on,
    ///   - fields: String array of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response. Any attribute in the full [comment](https://developer.box.com/reference#comment-object) objects can be
    ///     passed in the fields parameter to get specific attributes.
    ///   - completion: Returns a Comment response object if successful otherwise a BoxSDKError.
    public func update(
        commentId: String,
        message: String,
        fields: [String]? = nil,
        completion: @escaping Callback<Comment>
    ) {

        var json = [String: String]()
        if message.contains("@[") {
            json["tagged_message"] = message
        }
        else {
            json["message"] = message
        }

        boxClient.put(
            url: URL.boxAPIEndpoint("/2.0/comments/\(commentId)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: json,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Creates a comment on an item.
    ///
    /// - Parameters:
    ///   - itemId: The ID of the item to create a comment on.
    ///   - itemType: The type of the item to create a comment on. Can be "file" or "comment".
    ///   - fields: String array of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response. Any attributes in the full [comment](https://developer.box.com/reference#comment-object) objects can be
    ///     passed in the fields parameter to get specific attributes.
    ///   - completion: Returns a Comment response object if successful otherwise a BoxSDKError.
    public func create(
        itemId: String,
        itemType: String,
        message: String,
        fields: [String]? = nil,
        completion: @escaping Callback<Comment>
    ) {

        var json: [String: Any] = [
            "item": [
                "type": itemType,
                "id": itemId
            ]
        ]

        if message.contains("@[") {
            json["tagged_message"] = message
        }
        else {
            json["message"] = message
        }

        boxClient.post(
            url: URL.boxAPIEndpoint("/2.0/comments", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: json,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Deletes the comment.
    ///
    /// - Parameters:
    ///   - commentId: The ID of the comment to delete.
    ///   - completion: Returns Void if the comment is deleted.
    public func delete(
        commentId: String,
        completion: @escaping Callback<Void>
    ) {
        boxClient.delete(
            url: URL.boxAPIEndpoint("/2.0/comments/\(commentId)", configuration: boxClient.configuration),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }
}
