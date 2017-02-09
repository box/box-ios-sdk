//
//  BOXCommentUpdateRequest.h
//  BoxContentSDK
//

#import "BOXRequest.h"

@interface BOXCommentUpdateRequest : BOXRequest

@property (nonatomic, readwrite, strong) NSURL *sharedLinkURL;
@property (nonatomic, readwrite, strong) NSString *sharedLinkPassword; // Only required if the shared link is password-protected

@property (nonatomic, readonly, strong) NSString *commentID;

- (instancetype)initWithCommentID:(NSString *)commentID updatedMessage:(NSString *)updatedMessage;
- (void)performRequestWithCompletion:(BOXCommentBlock)completionBlock;

@end
