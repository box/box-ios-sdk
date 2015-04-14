//
//  BOXUser.h
//  BoxContentSDK
//
//

#import "BOXModel.h"
#import "BOXEnterprise.h"

/**
 *  A compact representation of a User with only a few properties.
 *  Some API requests will return these representations to reduce bandiwdth, especially when many
 *  instances are being returned.
 */
@interface BOXUserMini : BOXModel

/**
 *  Name of the user. May be nil if the user has not set the name in Box.
 */
@property (nonatomic, readwrite, strong) NSString *name;

/**
 *  Login of the user, usually an email address but not always.
 */
@property (nonatomic, readwrite, strong) NSString *login;

@end

/**
 *  Represents a User on Box.
 */
@interface BOXUser : BOXUserMini

/**
 *  Date the user was created.
 */
@property (nonatomic, readwrite, strong) NSDate *createdDate;

/**
 *  Date the user was modified.
 */
@property (nonatomic, readwrite, strong) NSDate *modifiedDate;

/**
 *  Language of the user.
 */
@property (nonatomic, readwrite, strong) NSString *language;

/**
 *  Timezone of the user.
 */
@property (nonatomic, readwrite, strong) NSString *timeZone;

/**
 *  The user’s total available space amount in bytes.
 */
@property (nonatomic, readwrite, strong) NSNumber *spaceAmount;

/**
 *  The amount of space in use by the user in bytes.
 */
@property (nonatomic, readwrite, strong) NSNumber *spaceUsed;

/**
 *  The maximum individual file size in bytes this user can have in bytes.
 */
@property (nonatomic, readwrite, strong) NSNumber *maxUploadSize;

/**
 *  Can be active, inactive. cannot_delete_edit, or cannot_delete_edit_upload.
 */
@property (nonatomic, readwrite, strong) NSString *status;

/**
 *  The user's job title.
 */
@property (nonatomic, readwrite, strong) NSString *jobTitle;

/**
 *  The user's phone number.
 */
@property (nonatomic, readwrite, strong) NSString *phone;

/**
 *  The user's address.
 */
@property (nonatomic, readwrite, strong) NSString *address;

/**
 *  URL of the user's avatar image.
 */
@property (nonatomic, readwrite, strong) NSURL *avatarURL;

/**
 *  This user’s enterprise role. Can be admin, coadmin, or user.
 *  Warning: By default, the Box API does not return this value, and it will be nil.
 *  You must request it by setting the "fields" of the request.
 */
@property (nonatomic, readwrite, strong) NSString *role;

/**
 *  An array of key/value pairs set by the user’s admin.
 *  Warning: By default, the Box API does not return this value, and it will be nil.
 *  You must request it by setting the "fields" of the request.
 */
@property (nonatomic, readwrite, strong) NSArray *trackingCodes;

/**
 *  Whether this user can see other enterprise users in her contact list.
 *  Warning: By default, the Box API does not return this value, and it will be BOXAPIBooleanUnknown.
 *  You must request it by setting the "fields" of the request.
 */
@property (nonatomic, readwrite, assign) BOXAPIBoolean canSeeManagedUsers;

/**
 *  Whether or not this user can use Box Sync.
 *  Warning: By default, the Box API does not return this value, and it will be BOXAPIBooleanUnknown.
 *  You must request it by setting the "fields" of the request.
 */
@property (nonatomic, readwrite, assign) BOXAPIBoolean isSyncEnabled;

/**
 *  Whether this user is allowed to collaborate with users outside her enterprise.
 *  Warning: By default, the Box API does not return this value, and it will be BOXAPIBooleanUnknown.
 *  You must request it by setting the "fields" of the request.
 */
@property (nonatomic, readwrite, assign) BOXAPIBoolean isExternalCollabRestricted;

/**
 *  Whether to exempt this user from Enterprise device limits.
 *  Warning: By default, the Box API does not return this value, and it will be BOXAPIBooleanUnknown.
 *  You must request it by setting the "fields" of the request.
 */
@property (nonatomic, readwrite, assign) BOXAPIBoolean isExemptFromDeviceLimits;

/**
 *  Whether or not this user must use two-factor authentication.
 *  Warning: By default, the Box API does not return this value, and it will be BOXAPIBooleanUnknown.
 *  You must request it by setting the "fields" of the request.
 */
@property (nonatomic, readwrite, assign) BOXAPIBoolean isExemptFromLoginVerification;

/**
 *  The enterprise the user belongs to.
 *  Warning: By default, the Box API does not return this value, and it will be nil.
 *  You must request it by setting the "fields" of the request.
 */
@property (nonatomic, readwrite, strong) BOXEnterpriseMini *enterprise;

@end
