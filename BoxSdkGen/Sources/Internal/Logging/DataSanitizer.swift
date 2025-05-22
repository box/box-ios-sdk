import Foundation

public class DataSanitizer {
    public let keysToSanitize: [String: String]

    public init() {
        self.keysToSanitize = ["authorization": "", "access_token": "", "refresh_token": "", "subject_token": "", "token": "", "client_id": "", "client_secret": "", "shared_link": "", "download_url": "", "jwt_private_key": "", "jwt_private_key_passphrase": "", "password": ""]
    }

    public func sanitizeHeaders(headers: [String: String]) -> [String: String] {
        return Utils.sanitizeMap(mapToSanitize: headers, keysToSanitize: self.keysToSanitize)
    }

    public func sanitizeBody(body: SerializedData) -> SerializedData {
        return JsonUtils.sanitizeSerializedData(sd: body, keysToSanitize: self.keysToSanitize)
    }

}
