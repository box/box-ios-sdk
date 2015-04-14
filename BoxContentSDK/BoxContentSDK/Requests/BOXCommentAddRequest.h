//
//  BOXCommentAddRequest.h
//  BoxContentSDK
//

#import "BOXRequest_Private.h"

@class BOXItem;

@interface BOXCommentAddRequest : BOXRequest

@property (nonatomic, readwrite, strong) NSString *taggedMessage;

@property (nonatomic, readwrite, strong) NSURL *sharedLinkURL;
@property (nonatomic, readwrite, strong) NSString *sharedLinkPassword; // Only required if the shared link is password-protected

- (instancetype)initWithFileID:(NSString *)fileID message:(NSString *)message;
- (instancetype)initWithBookmarkID:(NSString *)bookmarkID message:(NSString *)message;
- (instancetype)initWithCommentID:(NSString *)commentID message:(NSString *)message;

- (void)performRequestWithCompletion:(BOXCommentBlock)completionBlock;

@end
