import Foundation

/// A `Sequence` that reads data from an `InputStream` in chunks.
/// Conforms to the `Sequence` protocol and provides an iterator that yields chunks of data from the stream.
public struct StreamSequence: Sequence {
    /// The type of elements that this sequence yields.
    public typealias Element = InputStream

    /// The `InputStream` to read data from.
    private let inputStream: InputStream

    /// The size of each chunk to read from the `InputStream`.
    private let chunkSize: Int

    /// Initializes a `StreamSequence` with the given `InputStream` and chunk size.
    ///
    /// - Parameters:
    ///   - inputStream: The `InputStream` to read data from.
    ///   - chunkSize: The size of each chunk to read from the `InputStream`.
    init(inputStream: InputStream, chunkSize: Int) {
        self.inputStream = inputStream
        self.chunkSize = chunkSize
    }

    /// Creates and returns an iterator for this sequence.
    ///
    /// - Returns: A `StreamIterator` that reads data from the `InputStream` in chunks.
    public func makeIterator() -> StreamIterator {
        return StreamIterator(inputStream: inputStream, chunkSize: chunkSize)
    }
}

/// An iterator that reads data from an `InputStream` in chunks.
/// Conforms to the `IteratorProtocol` and yields chunks of data as `InputStream` objects.
public struct StreamIterator: IteratorProtocol {
    /// The type of elements that this iterator yields.
    public typealias Element = InputStream

    /// The `InputStream` to read data from.
    private let inputStream: InputStream

    /// The size of each chunk to read from the `InputStream`.
    private let chunkSize: Int

    /// A buffer to hold data read from the `InputStream`.
    private var buffer: [UInt8]

    /// A flag indicating whether there is more data to read from the `InputStream`.
    private var hasMoreData: Bool

    /// Initializes a `StreamIterator` with the given `InputStream` and chunk size.
    ///
    /// - Parameters:
    ///   - inputStream: The `InputStream` to read data from.
    ///   - chunkSize: The size of each chunk to read from the `InputStream`.
    init(inputStream: InputStream, chunkSize: Int) {
        self.inputStream = inputStream
        self.chunkSize = chunkSize
        self.buffer = [UInt8](repeating: 0, count: chunkSize)
        self.hasMoreData = true

        // Open the input stream for reading.
        inputStream.open()
    }

    /// Reads the next chunk of data from the `InputStream` and returns it as an `InputStream`.
    ///
    /// - Returns: An `InputStream` containing the next chunk of data, or `nil` if no more data is available.
    public mutating func next() -> InputStream? {
        guard hasMoreData else { return nil }

        // Read data into the buffer.
        let bytesRead = inputStream.read(&buffer, maxLength: chunkSize)

        if bytesRead > 0 {
            // Create and return an `InputStream` containing the read data.
            return MemoryInputStream(data: Data(bytes: buffer, count: bytesRead))
        } else {
            // No more data to read.
            hasMoreData = false
            inputStream.close()
            return nil
        }
    }
}
