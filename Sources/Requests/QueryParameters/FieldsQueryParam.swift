//
//  FieldsQueryParam.swift
//  BoxSDK-iOS
//
//  Created by Matthew Willer on 5/14/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

struct FieldsQueryParam {

    let fields: [String]?

    init(_ fields: [String]?) {
        self.fields = fields
    }
}

/// Defines query parameter string value
extension FieldsQueryParam: QueryParameterConvertible {

    /// Query parameter value
    public var queryParamValue: String? {
        return fields?.joined(separator: ",")
    }
}
