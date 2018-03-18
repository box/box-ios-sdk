//
//  BOXFileRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

typedef NS_OPTIONS(NSUInteger, BOXRepresentationRequestOptions) {
    BOXRepresentationRequestNoOptions                          = 0,       // Default option if no options set or permission to file not granted
    BOXRepresentationRequestOriginal                           = 1 << 0,  // Request original content url with file information request
    BOXRepresentationRequestHighDefinitionVideo                = 1 << 1,  // Request video representions if available for the given file
    BOXRepresentationRequestThumbnailRepresentation            = 1 << 2,  // Request thumbnail representions if available for the given file
    BOXRepresentationRequestLargeThumbnailRepresentation       = 1 << 3,  // Request large thumbnail representions are available for the given file
    BOXRepresentationRequestPDFRepresentation                  = 1 << 4,  // Request pdf representions if available for the given file
    BOXRepresentationRequestJPGRepresentation                  = 1 << 5,  // Request JPG representions if available for the given file
    BOXRepresentationRequestMP3Representation                  = 1 << 6,  // Request PNG representions if available for the given file
    BOXRepresentationRequestMP4Representation                  = 1 << 7,  // Request MP4 representions if available for the given file
    BOXRepresentationRequesteExtractedTextRepresentation       = 1 << 8   // Request extracted text if unformatted text is contained in a document (non-image)
} NS_ENUM_AVAILABLE_IOS(10_0);

@interface BOXFileRequest : BOXRequestWithSharedLinkHeader

@property (nonatomic, readwrite, assign) BOOL requestAllFileFields;

/**
 Ordered list of representation types, returns first representation type supported by the specified file type
 */
@property (nonatomic, readwrite, assign) BOOL matchSupportedRepresentation;

@property (nonatomic, readwrite, strong) NSArray *notMatchingEtags; //If-None-Match: Array of strings representing etag values

@property (nonatomic, readonly, strong) NSString *fileID;

// NOTE: Both the associateID and requestDirectoryPath values are required for performing the request in the background.
/**
 Caller provided unique ID to execute the request as a NSURLSession background task.
 This is a required value for performing the request in the background.
 */
@property (nonatomic, readwrite, strong) NSString *associateID;

/**
 Caller provided directory path for the result payload of the background operation to be written to.
 This is a required value for performing the request in the background.
 */
@property (nonatomic, readwrite, strong) NSString *requestDirectoryPath;


- (instancetype)initWithFileID:(NSString *)fileID;

- (instancetype)initWithFileID:(NSString *)fileID
                     isTrashed:(BOOL)isTrashed;

//Perform API request and any cache update only if refreshBlock is not nil
- (void)performRequestWithCompletion:(BOXFileBlock)completionBlock;

//Perform API request and any cache update only if refreshBlock is not nil
- (void)performRequestWithCached:(BOXFileBlock)cacheBlock
                       refreshed:(BOXFileBlock)refreshBlock;

/**
 Setting a representation or list option will include availability of file with request representation information
 */
- (void)setRepresentationRequestOptions:(BOXRepresentationRequestOptions)representationOptions, ... NS_REQUIRES_NIL_TERMINATION;

- (NSString *)formatRepresentationRequestHeader;

@end
