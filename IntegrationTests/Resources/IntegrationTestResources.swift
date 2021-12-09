//
//  IntegrationTestResources.swift
//  BoxSDKIntegrationTests-iOS
//
//  Created by Artur Jankowski on 17/12/2021.
//  Copyright © 2021 box. All rights reserved.
//

import Foundation
import UIKit

enum IntegrationTestResources: String {
    case smallImage = "small_image.png"
    case bigImage = "big_image.jpg"
    case smallPdf = "small_pdf.pdf"

    var fileName: String {
        return rawValue
    }
}
