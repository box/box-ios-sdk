//
//  BOXFileRequest.h
//  BoxContentSDK
//

#import "BOXRequestWithSharedLinkHeader.h"

@interface BOXFileRequest : BOXRequestWithSharedLinkHeader

@property (nonatomic, readwrite, assign) BOOL requestAllFileFields;
@property (nonatomic, readwrite, strong) NSArray *notMatchingEtags;//If-None-Match: Array of strings representing etag values

- (instancetype)initWithFileID:(NSString *)fileID;
- (instancetype)initWithFileID:(NSString *)fileID isTrashed:(BOOL)isTrashed;
- (void)performRequestWithCompletion:(BOXFileBlock)completionBlock;

@end
