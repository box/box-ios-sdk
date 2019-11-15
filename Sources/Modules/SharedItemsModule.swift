//
//  SharedLinksModule.swift
//  BoxSDK-iOS
//
//  Created by Cary Cheng on 6/10/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// Provides [SharedItem](../Structs/SharedItem.html) management.
public class SharedItemsModule {
    /// Required for communicating with BoxAPIs.
    weak var boxClient: BoxClient!
    // swiftlint:disable:previous implicitly_unwrapped_optional

    /// Initializer
    ///
    /// - Parameter boxClient: Required for communicating with Box APIs.
    init(boxClient: BoxClient) {
        self.boxClient = boxClient
    }

    /// Get the item back from the shared link.
    ///
    /// - Parameters:
    ///   - sharedLinkURL: The shared link of the item to retrieve.
    ///   - sharedLinkPassword: If the shared link has a password associated with it, the password will need to be provided.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to include in the response.
    ///   - completion: Returns a SharedItem response if successful or a BoxSDKError.
    public func get(
        sharedLinkURL: String,
        sharedLinkPassword: String? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<SharedItem>
    ) {
        var sharedLinkString = "shared_link=" + sharedLinkURL

        if let password = sharedLinkPassword {
            sharedLinkString += "&shared_link_password=" + password
        }

        let headers: [String: String] = [
            "BoxApi": sharedLinkString
        ]

        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/shared_items", configuration: boxClient.configuration),
            httpHeaders: headers,
            queryParameters: ["fields": FieldsQueryParam(fields)],
            completion: ResponseHandler.default(wrapping: completion)
        )
    }
}
