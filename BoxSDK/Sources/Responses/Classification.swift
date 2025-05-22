//
//  Classification.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 5/1/20.
//  Copyright © 2020 box. All rights reserved.
//

import Foundation

/// Details about the classification applied to a Box file or folder
public class Classification: BoxModel {
    // MARK: - Properties

    public private(set) var rawData: [String: Any]
    /// The color that is used to display the classification label in a user-interface
    public let color: PlatformColor?
    /// An explanation of the meaning of this classification
    public let definition: String?
    /// Name of the classification
    public let name: String?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        rawData = json
        color = try BoxJSONDecoder.optionalDecodeColor(json: json, forKey: "color")
        definition = try BoxJSONDecoder.optionalDecode(json: json, forKey: "definition")
        name = try BoxJSONDecoder.optionalDecode(json: json, forKey: "name")
    }
}
