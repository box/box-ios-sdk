//
//  ResponseHandler.swift
//  BoxSDK-iOS
//
//  Created by Matthew Willer on 8/1/19.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

/// Utility methods for common response handling
enum ResponseHandler {

    /// Make sure the response is successful (status code 2xx) and deserialize
    /// the response body into the appropriate type.
    ///
    /// - Parameter completion: The user-specified completion block to call with the resulting deserialized object
    static func `default`<T: BoxModel>(wrapping completion: @escaping Callback<T>) -> Callback<BoxResponse> {
        return { (result: Result<BoxResponse, BoxSDKError>) in
            let objectResult: Result<T, BoxSDKError> = result.flatMap { ObjectDeserializer.deserialize(data: $0.body) }
            completion(objectResult)
        }
    }

    /// Make sure the response is successful (status code 2xx) and deserialize
    /// the response body into the appropriate type.
    ///
    /// - Parameter completion: The user-specified completion block to call with the resulting deserialized object
    static func `default`<T: Decodable>(wrapping completion: @escaping Callback<T>) -> Callback<BoxResponse> {
        return { (result: Result<BoxResponse, BoxSDKError>) in
            let objectResult: Result<T, BoxSDKError> = result.flatMap { ObjectDeserializer.deserialize(response: $0) }
            completion(objectResult)
        }
    }

    /// Ensure the response was successful (status code 2xx) and transform to void result,
    /// for operations that do not return meaningful results — just success vs. failure.
    ///
    /// - Parameter completion: The user-specified completion block to call with the result
    static func `default`(wrapping completion: @escaping Callback<Void>) -> Callback<BoxResponse> {
        return { (result: Result<BoxResponse, BoxSDKError>) in
            let objectResult = result.map { _ in }
            completion(objectResult)
        }
    }

    /// This will help the user unwrap a response object that comes back as a collection where the collection
    /// is only of size one. This will give the user an Entry Container containing the Box Model expected.
    /// - Parameter completion: The user-specified completion block to call with the result
    static func unwrapCollection<T: BoxModel>(wrapping completion: @escaping Callback<T>) -> Callback<BoxResponse> {
        return { result in
            completion(result.flatMap {
                ObjectDeserializer.deserialize(data: $0.body).flatMap { (container: EntryContainer<T>) in
                    guard let entry = container.entries.first else {
                        return Result.failure(BoxCodingError(message: .typeMismatch(key: "entries")))
                    }
                    return Result.success(entry)
                }
            })
        }
    }

    static func pagingIterator<T: BoxModel>(
        client: BoxClient,
        wrapping completion: @escaping Callback<PagingIterator<T>>
    ) -> Callback<BoxResponse> {
        return { (result: Result<BoxResponse, BoxSDKError>) in
            switch result {
            case let .success(response):
                do {
                    let iterator = try PagingIterator<T>(response: response, client: client)
                    completion(.success(iterator))
                }
                catch let error as BoxSDKError {
                    print(error)
                    completion(.failure(error))
                }
                catch {
                    let errorMessage = "Iterator init throws error: \(error.localizedDescription)"
                    completion(.failure(BoxSDKError(message: .customValue(errorMessage), error: error)))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
