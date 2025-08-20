import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Handles redirect behavior for URLSession tasks on a per-task basis.
/// Allows enabling or disabling redirects for specific tasks using their taskIdentifier.
class RedirectHandler: NSObject, URLSessionDelegate, URLSessionTaskDelegate {

    /// Stores the identifiers of tasks that are allowed to follow redirects.
    private var allowRedirectTasks = Set<Int>()

    /// Lock to ensure thread-safe access to the `allowRedirectTasks` set.
    private let lock = NSLock()

    /// Sets whether a specific task is allowed to follow HTTP redirects.
    ///
    /// - Parameters:
    ///   - allowed: A boolean indicating whether the redirect is allowed.
    ///   - task: The URLSessionTask to configure.
    func setRedirectAllowed(_ allowed: Bool, for task: URLSessionTask) {
        lock.lock()
        defer { lock.unlock() }

        if allowed {
            allowRedirectTasks.insert(task.taskIdentifier)
        } else {
            allowRedirectTasks.remove(task.taskIdentifier)
        }
    }

    /// Called when a task receives a redirect response. Decides whether to follow the redirect.
    ///
    /// - Parameters:
    ///   - session: The URLSession instance.
    ///   - task: The URLSessionTask that received the redirect.
    ///   - response: The HTTPURLResponse that triggered the redirect.
    ///   - request: The new URLRequest proposed by the server.
    ///   - completionHandler: A closure that must be called with the new request to follow it, or nil to cancel the redirect.
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    willPerformHTTPRedirection response: HTTPURLResponse,
                    newRequest request: URLRequest,
                    completionHandler: @escaping (URLRequest?) -> Void) {
        lock.lock()
        let shouldRedirect = allowRedirectTasks.contains(task.taskIdentifier)
        lock.unlock()

        // Only follow the redirect if it was explicitly allowed for this task
        completionHandler(shouldRedirect ? request : nil)
    }

    /// Called when a task finishes, either successfully or with an error.
    /// Cleans up the redirect tracking for the task.
    ///
    /// - Parameters:
    ///   - session: The URLSession instance.
    ///   - task: The completed task.
    ///   - error: An error if the task failed, or nil if it completed successfully.
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        lock.lock()
        allowRedirectTasks.remove(task.taskIdentifier)
        lock.unlock()
    }
}
