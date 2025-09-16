import Foundation

public class CreateUserAvatarRequestBody {
    /// The image file to be uploaded to Box.
    /// Accepted file extensions are `.jpg` or `.png`.
    /// The maximum file size is 1MB.
    public let pic: InputStream

    public let picFileName: String?

    public let picContentType: String?

    /// Initializer for a CreateUserAvatarRequestBody.
    ///
    /// - Parameters:
    ///   - pic: The image file to be uploaded to Box.
    ///     Accepted file extensions are `.jpg` or `.png`.
    ///     The maximum file size is 1MB.
    ///   - picFileName: 
    ///   - picContentType: 
    public init(pic: InputStream, picFileName: String? = nil, picContentType: String? = nil) {
        self.pic = pic
        self.picFileName = picFileName
        self.picContentType = picContentType
    }

}
