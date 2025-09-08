//
//  URLSessionTaskExtension.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 5/14/20.
//  Copyright © 2020 box. All rights reserved.
//

import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

extension URLSessionTask: Cancellable {}
