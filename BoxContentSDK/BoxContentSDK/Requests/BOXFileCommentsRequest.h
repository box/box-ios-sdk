//
//  BOXFileCommentsRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXFileCommentsRequest : BOXRequestWithSharedLinkHeader

@property (nonatomic, readwrite, strong) NSURL *sharedLinkURL;
@property (nonatomic, readwrite, strong) NSString *sharedLinkPassword; // Only required if the shared link is password-protected

- (instancetype)initWithFileID:(NSString *)fileID;
- (void)performRequestWithCompletion:(BOXObjectsArrayCompletionBlock)completionBlock;

@end
