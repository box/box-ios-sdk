//
//  BoxAPIAuthError.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 10/15/19.
//  Copyright © 2019 box. All rights reserved.
//

/// Describes authentication errors.
public class BoxAPIAuthError: BoxAPIError {

    init(message: BoxSDKErrorEnum = "Error authenticating with the Box API", request: BoxRequest? = nil, response: BoxResponse? = nil, error: Error? = nil) {
        super.init(message: message, request: request, response: response, error: error)
        errorType = "BoxAPIAuthError"
    }
}
