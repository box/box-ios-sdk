//
//  ResourceTypeEntity.swift
//  BoxSDK-iOS
//
//  Created by Artur Jankowski on 09/08/2022.
//  Copyright © 2022 box. All rights reserved.
//

import Foundation

/// Represents simple resource type abstraction
public protocol ResourceTypeEntity: Encodable {
    /// The resource type of the assiociated object.
    var type: String { get }

    /// The id of the assiociated object
    var id: String { get }
}
