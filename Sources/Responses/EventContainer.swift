//
//  EventContainer.swift
//  BoxSDK
//
//  Created by Martina Stremeňová on 8/22/19.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

/// Container for Events
public class EventContainer: BoxModel {
    // MARK: - BoxModel

    public private(set) var rawData: [String: Any]

    // MARK: - Properties

    /// Number of events
    public let totalCount: Int?
    /// Events in a container
    public let entries: [Event]?
    /// Maximum number of events per page
    public let limit: Int?
    /// Defines next stream position in the stream
    public let nextStreamPosition: String?
    /// The number of event records contained in the object with entries.
    public let chunkSize: Int?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        rawData = json

        totalCount = try BoxJSONDecoder.optionalDecode(json: json, forKey: "total_count")
        limit = try BoxJSONDecoder.optionalDecode(json: json, forKey: "limit")
        entries = try BoxJSONDecoder.optionalDecodeCollection(json: json, forKey: "entries")
        chunkSize = try BoxJSONDecoder.optionalDecode(json: json, forKey: "chunk_size")
        guard let nextStreamPositionValue: Int64 = try BoxJSONDecoder.optionalDecode(json: json, forKey: "next_stream_position") else {
            nextStreamPosition = nil
            return
        }
        nextStreamPosition = String(nextStreamPositionValue)
    }
}
