import Foundation

extension Encodable {
    public func encode(with encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        return try encoder.encode(self)
    }
    
    public func serialize() throws -> SerializedData {
        return SerializedData(data: try self.encode())
    }
    
    public func serializeToString(with encoder: JSONEncoder = JSONEncoder()) throws -> String {
        return String(decoding: try self.encode(with: encoder), as: UTF8.self)
    }
}

extension Decodable {
    public static func decode(from data: Data, with decoder: JSONDecoder = JSONDecoder()) throws -> Self {
        let obj =  try decoder.decode(Self.self, from: data)
        
        if var jsonStorage = obj as? RawJSONStorage {
            jsonStorage.setRawData(JsonUtils.dataToJsonDictionary(from: data))
        }
        
        
        let jsonString = String(data: data, encoding: .utf8)
        
        return obj
    }
    
    public static func decode(string: String, with decoder: JSONDecoder = JSONDecoder()) throws -> Self {
        if let data = string.data(using: .utf8) {
            return try self.decode(from: data, with: decoder)
        }
        
        throw BoxSDKError(message: "Could not create `Data` from provided string")
    }
    
    public static func deserialize(from serializedData: SerializedData, with decoder: JSONDecoder = JSONDecoder()) throws -> Self {
        return try self.decode(from: serializedData.data, with: decoder)
    }
}


protocol RawJSONStorage {
    func setRawData(_ rawData: [String: Any]?)
}
