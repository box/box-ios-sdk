//
//  BOXPreflightCheckRequest.h
//  BoxContentSDK
//

#import "BOXRequest_Private.h"

@interface BOXPreflightCheckRequest : BOXRequest

@property (nonatomic, readonly, strong) NSString *fileName;
@property (nonatomic, readonly, strong) NSString *fileID;
@property (nonatomic, readonly, strong) NSString *parentFolderID;
@property (nonatomic, readwrite, assign) NSUInteger fileSize;

- (instancetype)initWithFileName:(NSString *)fileName fileID:(NSString *)fileID;
- (instancetype)initWithFileName:(NSString *)fileName parentFolderID:(NSString *)parentFolderID;

- (void)performRequestWithCompletion:(BOXErrorBlock)completionBlock;

@end
