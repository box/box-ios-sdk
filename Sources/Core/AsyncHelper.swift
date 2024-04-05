//
//  AsyncHelper.swift
//  BoxSDK-iOS
//
//  Created by Artur Jankowski on 19/05/2022.
//  Copyright © 2022 box. All rights reserved.
//

import Foundation

/// Provides method for converting Callback based API into an async API
@available(iOS 13.0, macOS 10.15, *)
public enum AsyncHelper {

    /// Converting a Callback based API into an async API.
    ///
    ///  Example of use:
    ///  -----------
    ///  let folder =  try? await AsyncHelper.asyncifyCallback { (callback: @escaping Callback<Folder>) in
    ///     client.folders.get(folderId: "12345", completion: callback)
    ///  }
    ///
    ///
    /// - Parameters:
    ///   - closure: A closure with API call based on Callback
    /// - Returns: Any result from the API call
    /// - Throws: BoxSDKError
    public static func asyncifyCallback<T>(closure: (@escaping Callback<T>) -> Void) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            closure { result in
                switch result {
                case let .success(data):
                    continuation.resume(returning: data)
                    return
                case let .failure(error):
                    continuation.resume(throwing: error)
                    return
                }
            }
        }
    }
}
