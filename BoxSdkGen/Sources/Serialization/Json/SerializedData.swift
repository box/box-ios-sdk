import Foundation

public class SerializedData {

    public let data: Data

    public init(data: Data) {
        self.data = data
    }

    internal func toUrlParams() throws -> String {
        return try Utils.Url.urlEncodedFrom(data: data)
    }

    internal func toJson() throws -> Data {
        return data
    }
}
