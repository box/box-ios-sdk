//
//  BOXUserRequest.h
//  BoxContentSDK
//

#import "BOXRequest_Private.h"

@interface BOXUserRequest : BOXRequest

/*
 By default BOXUserRequest will fetch all fields for a particular item. You can customize which exact fields to fetch
 by passing in a field string in the format of "field1, field2, field3".
 For detailed explaination and list of the fields please visit https://developers.box.com/docs/#users-user-object
 */
@property (nonatomic, readwrite, assign) BOOL requestAllUserFields;

//Perform API request and any cache update only if refreshBlock is not nil
- (void)performRequestWithCompletion:(BOXUserBlock)completionBlock;

//Perform API request and any cache update only if refreshBlock is not nil
- (void)performRequestWithCached:(BOXUserBlock)cacheBlock
                       refreshed:(BOXUserBlock)refreshBlock;

@end
