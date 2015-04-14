//
//  BOXCommentDeleteRequest.h
//  BoxContentSDK
//

#import "BOXRequest.h"

@interface BOXCommentDeleteRequest : BOXRequest

@property (nonatomic, readwrite, strong) NSURL *sharedLinkURL;
@property (nonatomic, readwrite, strong) NSString *sharedLinkPassword; // Only required if the shared link is password-protected

- (instancetype)initWithCommentID:(NSString *)commentID;
- (void)performRequestWithCompletion:(BOXErrorBlock)completionBlock;

@end
