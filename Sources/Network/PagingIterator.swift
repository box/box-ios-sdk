//
//  PagingIterator.swift
//  BoxSDK-iOS
//
//  Created by Matthew Willer, Albert Wu.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

public enum PagingParameter {

    case offset(Int)
    case marker(String?)
    case streamPosition(String?)

    var asQueryParams: QueryParameters {
        switch self {
        case let .offset(offset):
            return ["offset": offset]
        case let .marker(marker):
            return ["marker": marker]
        case let .streamPosition(streamPosition):
            return ["stream_position": streamPosition]
        }
    }
}

/// Provides paged iterator access for a collection of BoxModel's
public class PagingIterator<Element: BoxModel> {
    // swiftlint:disable force_unwrapping

    private let client: BoxClient

    public private(set) var nextPage: PagingParameter
    private var limit: Int
    private var isDone: Bool
    private var isStreamEmpty: Bool

    private let url: URL
    private let headers: BoxHTTPHeaders
    private var queryParams: QueryParameters

    private var buffer: Buffer<Element>
    private var dispatchQueue: DispatchQueue
    private var completionQueue: [Callback<Element>]?

    /// The total count of the result set, if known
    public let totalCount: Int?

    /// Initializer
    ///
    /// - Parameters:
    ///   - response: A BoxResponse from the API. The iterator is initialized from the data in the response.
    ///   - client: A BoxClient that will be used for any API calls the iterator makes internally in order to get more data.
    init(response: BoxResponse, client: BoxClient) throws {
        if !PagingIterator.isIterable(response: response) {
            throw BoxSDKError(message: .nonIterableResponse)
        }

        self.client = client

        let result: Result<EntryContainer<Element>, BoxSDKError> = ObjectDeserializer.deserialize(data: response.body)
        switch result {
        case let .success(page):
            if page.offset != nil {
                nextPage = .offset(page.offset!)
            }
            else if page.nextStreamPosition != nil {
                nextPage = .streamPosition(page.nextStreamPosition)
            }
            else if page.nextMarker != nil {
                nextPage = .marker(page.nextMarker)
            }
            else {
                // Default to a finished marker collection when there's no field present,
                // since some endpoints indicate completed paging this way
                nextPage = .marker(nil)
            }

            if page.limit != nil {
                limit = page.limit!
            }
            else {
                limit = page.entries.count
            }

            totalCount = page.totalCount

            isDone = false
            isStreamEmpty = false

            url = response.request.url
            headers = response.request.httpHeaders.filter { $0.key.lowercased() != "authorization" }
            queryParams = response.request.queryParams

            buffer = Buffer(page.entries)
            dispatchQueue = DispatchQueue(label: "com.box.swiftsdk.pagingiterator", qos: .userInitiated)

            updatePaging(page: page)

        case let .failure(error):
            throw error
        }
    }

    /// Update internal paging parameters to be used for the next API call
    private func updatePaging(page: EntryContainer<Element>) {
        switch nextPage {
        case let .offset(offset):
            nextPage = .offset(offset + limit)
            if page.totalCount != nil {
                isDone = page.offset! + limit > page.totalCount!
            }
            else {
                isDone = page.entries.isEmpty
            }
        case .marker:
            if page.nextMarker != nil {
                nextPage = .marker(page.nextMarker)
            }
            else {
                nextPage = .marker(nil)
                isDone = true
            }
        case .streamPosition:
            if page.entries.isEmpty {
                isStreamEmpty = true
            }
            nextPage = .streamPosition(page.nextStreamPosition)
        }
        queryParams = queryParams.merging(nextPage.asQueryParams) { _, right in right }
    }

    /// Gets next element from the iterator
    ///
    /// - Parameter completion: Returns either the next element or an error.
    ///             If the iterator has no more elements, a BoxSDKError with a
    ///             message of BoxSDKErrorEnum.noSuchElement is passed to the completion.
    public func next(completion: @escaping Callback<Element>) {
        // Access to the buffer and completion queue are protected by a serial dispatch queue to ensure thread safety
        dispatchQueue.async {
            // 1. Return buffered results, if there are any
            guard self.buffer.isEmpty() else {
                let element = self.buffer.removeFromHead()
                completion(.success(element))
                return
            }

            // 2. Return end-failure if iterator is done
            if self.isDone {
                completion(.failure(BoxSDKError(message: .endOfList)))
                return
            }

            // 3. If a completion queue is already set up, that means another page of results
            // is already on its way; we can just wait for it to arrive by adding this completion
            // to the completion queue
            guard self.completionQueue == nil else {
                self.completionQueue!.append(completion)
                return
            }

            // 4. There are no more results in the buffer and we need to request more from the API
            // 4a. Set up the completion queue and insert this completion as the first item,
            // so subsequent requests can queue behind this one
            self.completionQueue = [completion]

            // 4b. Get the next page of results from the API and load them into the buffer
            self.getData()
        }
    }

    /// Get the next page of items from the API
    private func getData() {
        self.client.get(
            url: url,
            httpHeaders: headers,
            queryParameters: queryParams
        ) { result in

            // Add an item on the dispatch queue to process the new page of results; this guarantees
            // that any previous calls to next() have already been added to the completion queue
            self.dispatchQueue.async {
                let pageResult: Result<EntryContainer<Element>, BoxSDKError> = result.flatMap {
                    ObjectDeserializer.deserialize(data: $0.body)
                }

                switch pageResult {
                case let .success(page):
                    // Update paging parameters for next API call
                    self.updatePaging(page: page)
                    // Set the buffer to the next page of results
                    self.buffer = Buffer(page.entries)

                    // distribute results in the buffer to waiting completions, in order
                    while !self.completionQueue!.isEmpty {

                        if self.buffer.isEmpty() {
                            if self.isDone || self.isStreamEmpty {
                                for queuedCompletion in self.completionQueue! {
                                    queuedCompletion(.failure(BoxSDKError(message: .endOfList)))
                                }
                                self.completionQueue = nil
                                return
                            }
                            // If the buffer runs out before we've satisfied all waiting completions, get the next page
                            // The completion queue is left in place at the current position and future calls to next() can wait behind existing ones
                            self.getData()
                            return
                        }

                        // Give the next element from the result set to the next completion,
                        // and remove the completion from the queue
                        let element = self.buffer.removeFromHead()
                        let queuedCompletion = self.completionQueue!.removeFirst()
                        queuedCompletion(.success(element))
                    }

                    self.completionQueue = nil

                case let .failure(error):
                    // If an API call fails completely, pass the error to all waiting completions
                    for queuedCompletion in self.completionQueue! {
                        queuedCompletion(.failure(error))
                    }

                    // Clear the completion queue so future calls to next() can retry
                    self.completionQueue = nil
                }
            }
        }
    }

    static func isIterable(response: BoxResponse) -> Bool {
        guard response.request.httpMethod == .get else {
            return false
        }
        guard let responseBody = response.body else {
            return false
        }

        let responseJSON = try? JSONSerialization.jsonObject(with: responseBody, options: []) as? [String: Any]
        guard let jsonDict = responseJSON else {
            return false
        }

        guard (jsonDict["entries"] as? [Any]) != nil else {
            return false
        }

        return true
    }

    // swiftlint:enable force_unwrapping
}

/// An ordered buffer of elements that provides constant-time removal of elements from the head of the buffer.
/// Uses constant space.
private class Buffer<Element> {

    // Removing from front of array is O(n), so maintain a private index
    // into buffer for the next element to return.
    // Reset buffer and index when needed.
    var buffer: [Element]
    var bufferIndex: Int

    init(_ elems: [Element] = []) {
        buffer = elems
        bufferIndex = 0
    }

    func isEmpty() -> Bool {
        return buffer.isEmpty || bufferIndex >= buffer.count
    }

    func removeFromHead() -> Element {
        let element = buffer[bufferIndex]
        bufferIndex += 1

        if isEmpty() {
            // Reset internal state because the buffer appears empty
            buffer = []
            bufferIndex = 0
        }

        return element
    }
}
