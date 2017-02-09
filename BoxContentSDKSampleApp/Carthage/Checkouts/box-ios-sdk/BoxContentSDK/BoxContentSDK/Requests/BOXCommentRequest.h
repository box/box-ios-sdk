//
//  BOXCommentRequest.h
//  BoxContentSDK
//

#import "BOXRequest.h"

@interface BOXCommentRequest : BOXRequest

@property (nonatomic, readwrite, assign) BOOL requestAllItemFields;
@property (nonatomic, readwrite, strong) NSURL *sharedLinkURL;
@property (nonatomic, readwrite, strong) NSString *sharedLinkPassword; // Only required if the shared link is password-protected
@property (nonatomic, readonly, strong) NSString *commentID;

- (instancetype)initWithCommentID:(NSString *)commentID;

//Perform API request and any cache update only if refreshBlock is not nil
- (void)performRequestWithCompletion:(BOXCommentBlock)completionBlock;

//Perform API request and any cache update only if refreshBlock is not nil
- (void)performRequestWithCached:(BOXCommentBlock)cacheBlock
                       refreshed:(BOXCommentBlock)refreshBlock;

@end
