//
//  BoxNetworkError.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 10/15/19.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

/// Describes network related errors.
public class BoxNetworkError: BoxSDKError {

    override init(message: BoxSDKErrorEnum = "Error with the network", error: Error? = nil) {
        super.init(message: message, error: error)
        errorType = "BoxNetworkError"
    }
}
