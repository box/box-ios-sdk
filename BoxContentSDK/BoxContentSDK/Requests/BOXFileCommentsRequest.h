//
//  BOXFileCommentsRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXFileCommentsRequest : BOXRequestWithSharedLinkHeader

@property (nonatomic, readwrite, assign) BOOL requestAllItemFields;
@property (nonatomic, readwrite, strong) NSURL *sharedLinkURL;
@property (nonatomic, readwrite, strong) NSString *sharedLinkPassword; // Only required if the shared link is password-protected
@property (nonatomic, readonly, strong) NSString *fileID;

- (instancetype)initWithFileID:(NSString *)fileID;
- (void)performRequestWithCompletion:(BOXObjectsArrayCompletionBlock)completionBlock;
- (void)performRequestWithCached:(BOXObjectsArrayCompletionBlock)cacheBlock
                       refreshed:(BOXObjectsArrayCompletionBlock)refreshBlock;
@end
