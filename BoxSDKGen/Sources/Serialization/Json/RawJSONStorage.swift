/// A protocol that defines the methods for setting and getting raw JSON data
protocol RawJSONReadable {

    /// Sets the raw JSON data
    /// - Parameter rawData: A dictionary containing the raw JSON data
    func setRawData(rawData: [String: Any]?)

    /// Gets the raw JSON data
    func getRawData() -> [String: Any]?
}
