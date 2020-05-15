//
//  BoxNetworkTask.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 3/21/20.
//  Copyright © 2020 box. All rights reserved.
//

import Foundation

protocol Cancellable {
    func cancel()
}

/// A Box network task request.
public class BoxNetworkTask: Cancellable {

    var tasks: [Cancellable] = []
    /// Whether the task is cancelled or not
    public internal(set) var cancelled: Bool = false

    /// Closure that is called when API calls are nested within each other
    func receiveTask(_ task: Cancellable) {
        if cancelled {
            cancel()
        }
        else {
            tasks.append(task)
        }
    }

    /// Method to cancel a Box Network Task
    public func cancel() {
        for task in tasks {
            task.cancel()
        }
        cancelled = true
    }
}
