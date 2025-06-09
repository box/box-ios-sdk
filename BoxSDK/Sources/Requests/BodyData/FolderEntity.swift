//
//  FolderEntity.swift
//  BoxSDK-iOS
//
//  Created by Artur Jankowski on 09/08/2022.
//  Copyright © 2022 box. All rights reserved.
//

import Foundation

/// Represents folder resource
public struct FolderEntity: ResourceTypeEntity {
    public private(set) var type: String
    public private(set) var id: String

    /// Initializer.
    ///
    /// - Parameters:
    ///   - id: Identifier of the folder.
    public init(id: String) {
        self.id = id
        type = "folder"
    }
}
