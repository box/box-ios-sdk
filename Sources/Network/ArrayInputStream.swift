/// Notes:
/// The purpose of this class (ArrayInputStream) is to "merge" multiple InputStreams into a single InputStream.
/// This merging can be implemented by sequentially reading from an array of input streams with an interface that is the same as InputStream.
/// This is done here by creating a subclass of InputStream that takes in an array of streams and has a custom read method that reads sequentially from its array of InputStreams.

// Copyright 2019 Soroush Khanlou
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
import Foundation

class ArrayInputStream: InputStream {
    // swiftlint:disable all

    private let inputStreams: [InputStream]

    private var currentIndex: Int
    private var _streamStatus: Stream.Status
    private var _streamError: Error?
    private var _delegate: StreamDelegate?

    init(inputStreams: [InputStream]) {
        self.inputStreams = inputStreams
        currentIndex = 0
        _streamStatus = .notOpen
        _streamError = nil
        super.init(data: Data()) // required because `init()` is not marked as a designated initializer
    }

    // Methods in the InputStream class that must be implemented
    override func read(_ buffer: UnsafeMutablePointer<UInt8>, maxLength: Int) -> Int {
        if _streamStatus == .closed {
            return 0
        }

        var totalNumberOfBytesRead = 0

        while totalNumberOfBytesRead < maxLength {
            if currentIndex == inputStreams.count {
                close()
                break
            }

            let currentInputStream = inputStreams[currentIndex]

            if currentInputStream.streamStatus != .open {
                currentInputStream.open()
            }

            if !currentInputStream.hasBytesAvailable {
                currentIndex += 1
                continue
            }

            let remainingLength = maxLength - totalNumberOfBytesRead

            let numberOfBytesRead = currentInputStream.read(&buffer[totalNumberOfBytesRead], maxLength: remainingLength)

            if numberOfBytesRead == 0 {
                currentIndex += 1
                continue
            }

            if numberOfBytesRead == -1 {
                _streamError = currentInputStream.streamError
                _streamStatus = .error
                return -1
            }

            totalNumberOfBytesRead += numberOfBytesRead
        }

        return totalNumberOfBytesRead
    }

    override func getBuffer(_: UnsafeMutablePointer<UnsafeMutablePointer<UInt8>?>, length _: UnsafeMutablePointer<Int>) -> Bool {
        return false
    }

    override var hasBytesAvailable: Bool {
        return true
    }

    // Methods and variables in the Stream class that must be implemented
    override func open() {
        guard _streamStatus == .open else {
            return
        }
        _streamStatus = .open
    }

    override func close() {
        _streamStatus = .closed
        for stream in inputStreams {
            stream.close()
        }
    }

    override func property(forKey _: Stream.PropertyKey) -> Any? {
        return nil
    }

    override func setProperty(_: Any?, forKey _: Stream.PropertyKey) -> Bool {
        return false
    }

    override var streamStatus: Stream.Status {
        return _streamStatus
    }

    override var streamError: Error? {
        return _streamError
    }

    override var delegate: StreamDelegate? {
        get {
            return _delegate
        }
        set {
            _delegate = newValue
        }
    }

    override func schedule(in _: RunLoop, forMode _: RunLoop.Mode) {}

    override func remove(from _: RunLoop, forMode _: RunLoop.Mode) {}

    // swiftlint:enable all
}
