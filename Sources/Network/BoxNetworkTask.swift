//
//  BoxNetworkTask.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 3/21/20.
//  Copyright © 2020 box. All rights reserved.
//

import Foundation

/// Represents Box Network Task request.
public class BoxNetworkTask {

    private var taskMethod: ((URLSessionTask) -> Void)?
    private var task: URLSessionTask?
    private var cancelled: Bool = false
}

extension BoxNetworkTask {
    internal func getTask() -> ((URLSessionTask) -> Void) {
        taskMethod = { sessionTask in
            if self.cancelBool {
                sessionTask.cancel()
            }
            else {
                self.task = sessionTask
            }
        }
        // swiftlint:disable:next force_unwrapping
        return taskMethod!
    }

    /// Method to cancel a network task
    public func cancel() {
        if let unwrappedTask = task {
            unwrappedTask.cancel()
        }
        else {
            cancelBool = true
        }
    }
}
