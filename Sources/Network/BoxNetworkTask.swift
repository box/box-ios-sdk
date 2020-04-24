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
    func receiveTask(_ sessionTask: URLSessionTask) {
        if self.cancelled {
            sessionTask.cancel()
        }
        else {
            self.task = sessionTask
        }
    }

    /// Method to cancel a network task
    public func cancel() {
        task?.cancel()
        cancelled = true
    }
}
