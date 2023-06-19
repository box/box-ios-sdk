//
//  AuthModuleDispatcher.swift
//  BoxSDK
//
//  Created by Daniel Cech on 13/06/2019.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

class AuthModuleDispatcher {

    // This queue must be serial, and protects access to the other stored properties
    private let queue = DispatchQueue.main
    // Actions which have yet to be processed
    private var actions: [AuthActionClosure] = []
    // Whether an action is currently processing
    private var actionInProgress = false

    /// Asynchronously run `action` at a time when no other actions are running.
    /// `action` must indicate that it is finished by calling its argument.
    func start(action: @escaping AuthActionClosure) {
        queue.async {
            self.actions.append(action)
            self.processActionOnQueue()
        }
    }

    // This MUST be called on `queue`
    private func processActionOnQueue() {
        guard !actionInProgress else {
            return
        }
        guard !actions.isEmpty else {
            return
        }

        actionInProgress = true
        let action = actions.removeFirst()
        action {
            self.queue.async {
                self.actionInProgress = false
                self.processActionOnQueue()
            }
        }
    }
}
