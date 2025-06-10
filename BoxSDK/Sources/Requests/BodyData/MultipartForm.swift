//
//  MultipartForm.swift
//  BoxSDK-iOS
//
//  Created by Matthew Willer on 5/21/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// Representation of a multipart form request body.
public struct MultipartForm {
    private var parts: [MultipartFormPart]

    /// Initialize an empty form.
    public init() {
        parts = []
    }

    /// Append a body part to the form.
    ///
    /// - Parameters:
    ///   - name: The name of the part.
    ///   - contents: The raw data to include in the body part.
    public mutating func appendPart(name: String, contents: Data) {
        parts.append(MultipartFormPart(name: name, contents: contents))
    }

    /// Append a file body part to the form.
    ///
    /// - Parameters:
    ///   - name: The name of the part.
    ///   - contents: A stream containing the file contents.
    ///   - length: The number of bytes in the file.
    ///   - fileName: The name of the file.
    ///   - mimeType: The content type of the file.
    public mutating func appendFilePart(name: String, contents: InputStream, length: Int, fileName: String, mimeType: String) {
        parts.append(MultipartFormPart(name: name, contents: contents, length: length, fileName: fileName, mimeType: mimeType))
    }

    /// Get the parts currently added to the form.
    ///
    /// - Returns: The list of form parts.
    func getParts() -> [MultipartFormPart] {
        return parts
    }
}

/// Representation of a single multipart form part.
struct MultipartFormPart {

    enum ContentData {
        case data(Data)
        case stream(InputStream)
    }

    let name: String
    let mimeType: String?
    let fileName: String?
    let contents: ContentData
    let length: Int

    /// Initialize a basic part.
    ///
    /// - Parameters:
    ///   - name: The name of the part.
    ///   - contents: The raw data of the part body.
    init(name: String, contents: Data) {
        self.name = name
        self.contents = .data(contents)
        fileName = nil
        mimeType = nil
        length = contents.count
    }

    /// Initialize a file part.
    ///
    /// - Parameters:
    ///   - name: The name of the part.
    ///   - contents: The stream of file contents.
    ///   - length: The size of the file.
    ///   - fileName: The name of the file.
    ///   - mimeType: The content type of the file.
    init(name: String, contents: InputStream, length: Int, fileName: String, mimeType: String) {
        self.name = name
        self.contents = .stream(contents)
        self.fileName = fileName
        self.mimeType = mimeType
        self.length = length
    }
}
