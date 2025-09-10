import Foundation

/// A custom `InputStream` implementation that reads data from an in-memory `Data` object.
class MemoryInputStream: InputStream {
    private var data: Data
    private var position: Int = 0
    private var _streamStatus: Stream.Status
    private var _streamError: Error?
    private var _delegate: StreamDelegate?

    /// Initializes a new `MemoryInputStream` with the provided data.
    /// - Parameter data: The `Data` object containing the data to be read.
    override init(data: Data) {
        self.data = data
        self._streamStatus = .notOpen
        super.init(data: Data())
    }

    /// Reads up to a specified number of bytes into the provided buffer.
    /// - Parameters:
    ///   - buffer: A buffer to which the data will be read.
    ///   - len: The maximum number of bytes to read.
    /// - Returns: The number of bytes actually read, or `-1` if an error occurred or the stream is not open.
    override func read(_ buffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) -> Int {
        guard _streamStatus == .open else {
            return -1 // Stream must be open to read
        }

        // If we've reached the end of the buffer, mark the stream as atEnd
        if position >= data.count {
            _streamStatus = .atEnd
            return 0
        }

        // Calculate the number of bytes to read
        let bytesToRead = min(len, data.count - position)

        // Copy data to the buffer
        let range = position..<position + bytesToRead
        data.copyBytes(to: buffer, from: range)

        // Update the position
        position += bytesToRead

        if position >= data.count {
            _streamStatus = .atEnd
        }

        return bytesToRead
    }

    /// Indicates whether there are bytes available to read.
    /// - Returns: `true` if there are bytes available and the stream is open; otherwise, `false`.
    override var hasBytesAvailable: Bool {
        return position < data.count && _streamStatus == .open
    }

    /// Closes the stream, marking the end of the data.
    override func close() {
        position = data.count
        _streamStatus = .closed
    }

    /// Resets the stream to its initial state.
    /// The position is reset to the beginning of the data and the stream status is set to not open.
    func reset() {
        position = 0
        _streamStatus = .notOpen
    }

    /// Opens the stream for reading.
    /// The position is reset to the beginning of the data and the stream status is set to open.
    override func open() {
        position = 0
        _streamStatus = .open
    }

    /// The current status of the stream.
    override var streamStatus: Stream.Status {
        return _streamStatus
    }

    /// The error encountered by the stream, if any.
    override var streamError: Error? {
        return _streamError
    }

    /// The delegate of the stream.
    override var delegate: StreamDelegate? {
        get {
            return _delegate
        }
        set {
            _delegate = newValue
        }
    }

    /// Schedules the stream in a run loop. This method does nothing in this implementation.
    /// - Parameters:
    ///   - runLoop: The run loop in which to schedule the stream.
    ///   - mode: The run loop mode in which to schedule the stream.
    override func schedule(in _: RunLoop, forMode _: RunLoop.Mode) {}

    /// Removes the stream from a run loop. This method does nothing in this implementation.
    /// - Parameters:
    ///   - runLoop: The run loop from which to remove the stream.
    ///   - mode: The run loop mode from which to remove the stream.
    override func remove(from _: RunLoop, forMode _: RunLoop.Mode) {}

#if os(iOS) || os(macOS)
    /// Returns the value of a specified property key. This method always returns `nil` in this implementation.
    /// - Parameter key: The property key.
    /// - Returns: `nil`.
    override func property(forKey _: Stream.PropertyKey) -> Any? {
        return nil
    }

    /// Sets the value of a specified property key. This method always returns `false` in this implementation.
    /// - Parameters:
    ///   - property: The property value to set.
    ///   - key: The property key.
    /// - Returns: `false`.
    override func setProperty(_: Any?, forKey _: Stream.PropertyKey) -> Bool {
        return false
    }
#endif
}
