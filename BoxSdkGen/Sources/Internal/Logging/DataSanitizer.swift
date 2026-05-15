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

    public func sanitizeFormEncodedBody(body: String) -> String {
        return JsonUtils.sanitizeFormEncodedBodyFromString(body: body, keysToSanitize: self.keysToSanitize)
    }

    public func sanitizeStringBody(body: String, contentType: String? = nil) -> String {
        if contentType == "application/json" || contentType == "application/json-patch+json" {
            do {
                return try JsonUtils.sdToJsonString(data: self.sanitizeBody(body: JsonUtils.jsonToSerializedData(text: body)))
            } catch {
                return body
            }

        }

        if contentType == "application/x-www-form-urlencoded" {
            return self.sanitizeFormEncodedBody(body: body)
        }

        return body
    }

}
