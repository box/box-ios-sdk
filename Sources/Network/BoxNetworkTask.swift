//
//  BoxNetworkTask.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 3/21/20.
//  Copyright © 2020 box. All rights reserved.
//

import Foundation

/// A Box network task request.
public class BoxNetworkTask {

    var task: URLSessionTask?
    /// Whether the task is cancelled or not
    public internal(set) var cancelled: Bool = false

    /// Closure that is called when a task has been created for an API call
    func receiveTask(_ sessionTask: URLSessionTask) {
        if cancelled {
            sessionTask.cancel()
        }
        else {
            task = sessionTask
        }
    }

    /// Method to cancel a Box Network Task
    public func cancel() {
        task?.cancel()
        cancelled = true
    }
}