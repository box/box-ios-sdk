//
//  EntryContainerInnerModel.swift
//  BoxSDK-iOS
//
//  Created by Cary Cheng on 6/19/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// Entry container for items of inner model
public class EntryContainerInnerModel<T: BoxInnerModel>: BoxInnerModel {
    // MARK: - BoxInnerModel

    private enum CodingKeys: String, CodingKey {
        case entries
    }

    // MARK: - Properties

    /// Container entries
    public let entries: [T]?
}
