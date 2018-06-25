//
//  BOXFileRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"


/**
 Representations are digital assets created for files stored in Box. To request representations information for
 a file, set the options for each type.
 
 - BOXRepresentationRequestOriginal:                        Request original content url with file information request
                                                            Reference the reponse field 'authenticated_download_url' to download original content when file
                                                            has download permissions are owner, co-owner, editor, viewer uploader, viewer
 - BOXRepresentationRequestAllRepresentations:              If permissions allow retrieve representations for thumbnails, preview representations for the given file
 - BOXRepresentationRequestHighDefinitionVideo:             Request video representions if available for the given file
 - BOXRepresentationRequestThumbnailRepresentation:         Request thumbnail representions if available for the given file
 - BOXRepresentationRequestLargeThumbnailRepresentation:    Request large thumbnail representions are available for the given file
 - BOXRepresentationRequestPDFRepresentation:               Request PDF representions if available for the given file
 - BOXRepresentationRequestJPGRepresentation:               Request JPG representions if available for the given file
 - BOXRepresentationRequestMP3Representation:               Request PNG representions if available for the given file
 - BOXRepresentationRequestMP4Representation:               Request MP4 representions if available for the given file
 - BOXRepresentationRequesteExtractedTextRepresentation:    Request extracted text if unformatted text is contained in a document (non-image)
 */
typedef NS_ENUM(NSUInteger, BOXRepresentationRequestOptions) {
    BOXRepresentationRequestOriginal,
    BOXRepresentationRequestAllRepresentations,
    BOXRepresentationRequestHighDefinitionVideo,
    BOXRepresentationRequestThumbnailRepresentation,
    BOXRepresentationRequestLargeThumbnailRepresentation,
    BOXRepresentationRequestPDFRepresentation,
    BOXRepresentationRequestJPGRepresentation,
    BOXRepresentationRequestMP3Representation,
    BOXRepresentationRequestMP4Representation,
    BOXRepresentationRequesteExtractedTextRepresentation
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
 Setting a representation or Array of options will include availability for that file when request representation information
 */
- (void)setRepresentationRequestOptions:(NSArray *)representationOptions;

- (NSString *)formatRepresentationRequestHeader;

@end
