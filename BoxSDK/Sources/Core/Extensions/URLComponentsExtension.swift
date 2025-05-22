//
//  URLComponentsExtension.swift
//  BoxSDK
//
//  Created by Daniel Cech on 10/04/2019.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

extension URLComponents {

    mutating func setQueryItems(with parameters: [String: String]) {
        queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
