//
//  BOXBookmarkCreateRequest.h
//  BoxContentSDK
//

#import "BOXRequest_Private.h"

@interface BOXBookmarkCreateRequest : BOXRequest

@property (nonatomic, readonly, strong) NSURL *URL;
@property (nonatomic, readonly, strong) NSString *parentFolderID;
@property (nonatomic, readwrite, strong) NSString *bookmarkName;
@property (nonatomic, readwrite, strong) NSString *bookmarkDescription;

- (instancetype)initWithURL:(NSURL *)URL parentFolderID:(NSString *)parentFolderID;

- (void)performRequestWithCompletion:(BOXBookmarkBlock)completionBlock;

@end
