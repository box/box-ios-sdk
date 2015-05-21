//
//  BOXModel.h
//  BoxContentSDK
//
//

#import "BOXContentSDKConstants.h"
#import "NSJSONSerialization+BOXAdditions.h"
#import "NSDate+BOXAdditions.h"
#import "BOXLog.h"

/**
 Base class for all BOXModel objects.
 */
@interface BOXModel : NSObject

/**
 Some model object properties are not necessarily set because the API did not return a value for them.
 For boolean properties, we allow for an "unknown" state by using this enum instead of a BOOL.
 */
typedef enum {
    BOXAPIBooleanUnknown = 0,
    BOXAPIBooleanYES,
    BOXAPIBooleanNO,
} BOXAPIBoolean;

/**
 *  Primary key ID of the model object.
 */
@property (nonatomic, readwrite, strong) NSString *modelID;

/**
 *  Type of the model object represented as a string.
 */
@property (nonatomic, readwrite, strong) NSString *type;

/**
 *  JSON response data.
 */
@property (nonatomic, readwrite, strong) NSDictionary *JSONData;

/**
 *  Initialize with a dictionary from Box API response JSON.
 *
 *  @param Dictionary from Box API response JSON.
 *
 *  @return The model object.
 */
- (instancetype)initWithJSON:(NSDictionary *)JSONData;

@end
