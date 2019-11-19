//
//  BoxAPIError.swift
//  BoxSDK
//
//  Created by Daniel Cech on 10/05/2019.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// Describes API request related errors.
public class BoxAPIError: BoxSDKError {
    public var request: BoxRequestDescription?
    public var response: BoxResponseDescription?

    init(message: BoxSDKErrorEnum? = nil, request: BoxRequest? = nil, response: BoxResponse? = nil, error: Error? = nil) {
        super.init(error: error)
        errorType = "BoxAPIError"

        if let unwrappedMessage = message {
            self.message = unwrappedMessage
        }
        else {
            self.message = BoxSDKErrorEnum.customValue("Error from the Box API")
        }

        if let unwrappedRequest = request {
            self.request = BoxRequestDescription(fromRequest: unwrappedRequest)
        }
        else {
            self.request = nil
        }

        if let unwrappedResponse = response {

            let responseDescription = BoxResponseDescription(fromResponse: unwrappedResponse)
            self.response = responseDescription

            if message == nil {
                var formattedMessage = "The API returned an unexpected response: "
                if let statusCode = responseDescription.statusCode {
                    formattedMessage += "[\(statusCode) \(HTTPURLResponse.localizedString(forStatusCode: statusCode).capitalized)"

                    var bodyRequestID = ""
                    if let responseBodyDict = responseDescription.body, let requestId = responseBodyDict["request_id"] as? String {
                        bodyRequestID = requestId
                    }

                    if !bodyRequestID.isEmpty {
                        formattedMessage += " | \(bodyRequestID)] "
                    }
                    else {
                        formattedMessage += "] "
                    }
                }

                if let responseBody = responseDescription.body {
                    if let code = responseBody["code"] as? String, let detailedMessage = responseBody["message"] as? String {
                        formattedMessage += "\(code) - \(detailedMessage)"
                    }
                    // Some authentication errors have different format
                    else if let error = responseBody["error"] as? String, let errorDescription = responseBody["error_description"] as? String {
                        formattedMessage += "\(error) - \(errorDescription)"
                    }
                }
                self.message = BoxSDKErrorEnum.customValue(formattedMessage)
            }
        }
        else {
            self.response = nil
        }
    }

    public override func getDictionary() -> [String: Any] {
        var dict = super.getDictionary()
        dict["request"] = request?.getDictionary()
        dict["response"] = response?.getDictionary()
        return dict
    }
}
