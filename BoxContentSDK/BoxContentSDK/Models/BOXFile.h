//
//  BOXFile.h
//  BoxContentSDK
//
//

#import "BOXItem.h"

@class BOXFileLock;

/**
 *  A compact representation of a Bookmark with only a few properties.
 *  Some API requests will return these representations to reduce bandiwdth, especially when many
 *  instances are being returned.
 */
@interface BOXFileMini : BOXItemMini
@end

/**
 *  Represents a File on Box.
 */
@interface BOXFile : BOXItem

/**
 *  The SHA1 hash of the file.
 */
@property (nonatomic, readwrite, strong) NSString *SHA1;

/**
 *  The version of the file.
 *  Warning: By default, the Box API does not return this value, and it will be nil.
 *  You must request it by setting the "fields" of the request.
 */
@property (nonatomic, readwrite, strong) NSString *versionNumber;

/**
 *  The number of comments that have been made on the file.
 *  Warning: By default, the Box API does not return this value, and it will be nil.
 *  You must request it by setting the "fields" of the request.
 */
@property (nonatomic, readwrite, strong) NSNumber *commentCount;

/**
 *  The extension of the file.
 *  Warning: By default, the Box API does not return this value, and it will be nil.
 *  You must request it by setting the "fields" of the request.
 */
@property (nonatomic, readwrite, strong) NSString *extension;

/**
 *  Indicates permission for the current user to download the file.
 *  Warning: By default, the Box API does not return this value, and it will be BOXAPIBooleanUnknown.
 *  You must request it by setting the "fields" of the request.
 */
@property (nonatomic, readwrite, assign) BOXAPIBoolean canDownload;

/**
 *  Indicates permission for the current user to preview the file.
 *  Warning: By default, the Box API does not return this value, and it will be BOXAPIBooleanUnknown.
 *  You must request it by setting the "fields" of the request.
 */
@property (nonatomic, readwrite, assign) BOXAPIBoolean canPreview;

/**
 *  Indicates permission for the current user to upload new versions of the file.
 *  Warning: By default, the Box API does not return this value, and it will be BOXAPIBooleanUnknown.
 *  You must request it by setting the "fields" of the request.
 */
@property (nonatomic, readwrite, assign) BOXAPIBoolean canUpload;

/**
 *  Indicates permission for the current user to comment on the file.
 *  Warning: By default, the Box API does not return this value, and it will be BOXAPIBooleanUnknown.
 *  You must request it by setting the "fields" of the request.
 */
@property (nonatomic, readwrite, assign) BOXAPIBoolean canComment;

/**
 *  Whether the file is a package. Used for Mac Packages used by iWorks.
 *  Warning: By default, the Box API does not return this value, and it will be BOXAPIBooleanUnknown.
 *  You must request it by setting the "fields" of the request.
 */
@property (nonatomic, readwrite, assign) BOXAPIBoolean isPackage;

/**
 *  A lock held on the file.
 *  Warning: By default, the Box API does not return this value, and it will be nil.
 *  You must request it by setting the "fields" of the request.
 */
@property (nonatomic, readwrite, strong) BOXFileLock *lock;

@end
