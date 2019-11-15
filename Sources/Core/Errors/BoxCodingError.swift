//
//  BoxCodingError.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 10/15/19.
//  Copyright © 2019 box. All rights reserved.
//
import Foundation

/// Describes encoding and decoding related errors.
public class BoxCodingError: BoxSDKError {

    override init(message: BoxSDKErrorEnum = "Error with encoding or decoding", error: Error? = nil) {
        super.init(message: message, error: error)
        errorType = "BoxCodingError"
    }
}
