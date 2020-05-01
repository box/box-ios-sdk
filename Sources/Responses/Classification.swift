//
//  Classification.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 5/1/20.
//  Copyright © 2020 box. All rights reserved.
//

import Foundation

/// Details about the classification applied to a Box file or folder
public class Classification: BoxInnerModel {
    // MARK: - Properties

    /// The color that is used to display the classification label in a user-interface
    public let color: String?
    /// An explanation of the meaning of this classification
    public let definition: String?
    /// Name of the classification
    public let name: String?
}
