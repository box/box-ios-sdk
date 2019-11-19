//
//  ObjectDeserializer.swift
//  BoxSDK
//
//  Created by Daniel Cech on 05/04/2019.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

enum ObjectDeserializer {

    static func deserialize<ReturnType: BoxModel>(data: Data?) -> Result<ReturnType, BoxSDKError> {

        guard let bodyData = data else {
            return .failure(BoxCodingError(message: "Invalid response to deserialize"))
        }

        // swiftlint:disable:next force_unwrapping
        let responseJsonData = bodyData.isEmpty ? "{}".data(using: .utf8)! : bodyData

        let responseJSON = try? JSONSerialization.jsonObject(with: responseJsonData, options: []) as? [String: Any]
        guard let jsonDict = responseJSON else {
            return .failure(BoxCodingError(message: "Invalid response to deserialize"))
        }

        do {
            let boxResponse = try ReturnType(json: jsonDict)
            return .success(boxResponse)
        }
        catch {
            return .failure(BoxCodingError(error: error))
        }
    }

    static func deserialize<ReturnType: Decodable>(response: BoxResponse) -> Result<ReturnType, BoxSDKError> {

        guard let bodyData = response.body else {
            return .failure(BoxCodingError(message: "Invalid response to deserialize"))
        }
        // swiftlint:disable:next force_unwrapping
        let responseJsonData = bodyData.isEmpty ? "{}".data(using: .utf8)! : bodyData

        do {
            let boxResponse = try responseBodyDecoder.decode(ReturnType.self, from: responseJsonData)
            return .success(boxResponse)
        }
        catch {
            return .failure(BoxCodingError(error: error))
        }
    }
}
