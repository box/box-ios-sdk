//
//  MetadataFilterQueryParam.swift
//  BoxSDK-iOS
//
//  Created by Cary Cheng on 7/18/19.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

struct MetadataFilterQueryParam {

    let metadataFilter: MetadataSearchFilter?

    init(_ metadataFilter: MetadataSearchFilter?) {
        self.metadataFilter = metadataFilter
    }
}

extension MetadataFilterQueryParam: QueryParameterConvertible {

    public var queryParamValue: String? {
        guard let filter = self.metadataFilter else {
            return nil
        }
        // swiftlint:disable:next force_unwrapping
        let filterString = try? filter.filterArray.map { String(data: try queryParameterEncoder.encode($0), encoding: .utf8)! }
            .joined(separator: ",")

        guard let unwrappedFilterString = filterString else {
            return nil
        }
        return "[\(unwrappedFilterString)]"
    }
}
