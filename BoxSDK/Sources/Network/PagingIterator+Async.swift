//
//  PagingIterator+Async.swift
//  BoxSDK-iOS
//
//  Created by Artur Jankowski on 20/05/2022.
//  Copyright © 2022 box. All rights reserved.
//

import Foundation

/// Provides paged iterator access for a collection of BoxModel's
@available(iOS 13.0, macOS 10.15, *)
public extension PagingIterator {

    /// Gets next page of elements from the iterator
    ///
    /// - Returns: Either the next page of elements or an error.
    ///   If the iterator has no more elements, a BoxSDKError with a
    ///   message of BoxSDKErrorEnum.endOfList is returned.
    func next() async throws -> EntryContainer<Element> {
        return try await AsyncHelper.asyncifyCallback { (callback: @escaping Callback<EntryContainer<Element>>) in
            self.next(completion: callback)
        }
    }
}
