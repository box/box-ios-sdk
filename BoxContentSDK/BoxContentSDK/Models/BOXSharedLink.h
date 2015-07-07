//
//  BOXSharedLink.h
//  BoxContentSDK
//
//

#import "BOXModel.h"
#import "BOXContentSDKConstants.h"

/**
 *  Represents a shared link.
 */
@interface BOXSharedLink : NSObject

/**
 *  URL of the shared link.
 */
@property (nonatomic, readwrite, strong) NSURL *url;

/**
 *  Direct download URL.
 */
@property (nonatomic, readwrite, strong) NSURL *downloadURL;

/**
 *  Vanity URL that may have been set for the link.
 */
@property (nonatomic, readwrite, strong) NSURL *vanityURL;

/**
 *  Whether or not a password is required to access the underlying item.
 */
@property (nonatomic, readwrite, assign) BOXAPIBoolean isPasswordEnabled;

/**
 *  Access level for the shared link.
 */
@property (nonatomic, readwrite, strong) BOXSharedLinkAccessLevel *accessLevel;

/**
 *  Effective access level for the shared link.
 *  Could be more restrictive than the access level set on the shared link because of
 *  restrictions from the enterprise admin, or parent folder that went into effect after
 *  the link's creation.
 */
@property (nonatomic, readwrite, strong) BOXSharedLinkAccessLevel *effectiveAccessLevel;

/**
 *  Whether or not the underlying item can be downloaded.
 */
@property (nonatomic, readwrite, assign) BOXAPIBoolean canDownload;

/**
 *  Whether or not the underlying item can be previewed.
 */
@property (nonatomic, readwrite, assign) BOXAPIBoolean canPreview;

/**
 *  Expiration date for the shared link.
 */
@property (nonatomic, readwrite, strong) NSDate *expirationDate;

/**
 *  The number of times the underlying item has been downloaded.
 */
@property (nonatomic, readwrite, strong) NSNumber *downloadCount;

/**
 *  The number of times the underlying item has been previewed.
 */
@property (nonatomic, readwrite, strong) NSNumber *previewCount;

/**
 *  JSON response data.
 */
@property (nonatomic, readwrite, strong) NSDictionary *JSONData;

/**
 *  Initialize with API JSON response dictionary.
 *
 *  @param JSONResponse Dictionary from JSON response.
 *
 *  @return BOXSharedLink instance.
 */
- (instancetype)initWithJSON:(NSDictionary *)JSONResponse;

@end
