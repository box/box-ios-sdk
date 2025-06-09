//
//  FolderItem+Extensions.swift
//  BoxSDKIntegrationTests-iOS
//
//  Created by Artur Jankowski on 15/12/2021.
//  Copyright © 2021 box. All rights reserved.
//

import BoxSDK
import Foundation

extension FolderItem {
    var folder: Folder? {
        if case let .folder(folder) = self {
            return folder
        }

        return nil
    }
}
