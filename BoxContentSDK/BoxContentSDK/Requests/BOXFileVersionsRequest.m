//
//  BOXFileVersionsRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXFileVersionsRequest.h"

#import "BOXAPIJSONOperation.h"
#import "BOXFileVersion.h"

@interface BOXFileVersionsRequest ()
@property (nonatomic, readonly, strong) NSString *fileID;
@end

@implementation BOXFileVersionsRequest

- (instancetype)initWithFileID:(NSString *)fileID
{
    if (self = [super init]) {
        _fileID = fileID;
    }
    
    return self;
}

- (BOXAPIOperation *)createOperation
{
    NSURL *URL = [self URLWithResource:BOXAPIResourceFiles
                                    ID:self.fileID
                           subresource:BOXAPISubresourceVersions
                                 subID:nil];
    
    BOXAPIJSONOperation *JSONoperation = [self JSONOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodGET
                                              queryStringParameters:nil
                                                     bodyDictionary:nil
                                                   JSONSuccessBlock:nil
                                                       failureBlock:nil];
    
    return JSONoperation;
}

- (void)performRequestWithCompletion:(BOXObjectsArrayCompletionBlock)completionBlock
{
    BOOL isMainThread = [NSThread isMainThread];
    BOXAPIJSONOperation *commentsOperation = (BOXAPIJSONOperation *)self.operation;
    
    if (completionBlock) {
        commentsOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock([self fileVersionsFromJSONDictionary:JSONDictionary] ,nil);
            } onMainThread:isMainThread];
        };
        commentsOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil,error);
            } onMainThread:isMainThread];
        };
    }
    
    [self performRequest];
}

#pragma mark - Private Helpers

- (NSArray *)fileVersionsFromJSONDictionary:(NSDictionary *)JSONDictionary
{
    NSArray *entries = [JSONDictionary objectForKey:@"entries"];
    NSMutableArray *fileVersions = [NSMutableArray arrayWithCapacity:entries.count];
    
    for (NSDictionary *dict in entries) {
        [fileVersions addObject:[[BOXFileVersion alloc] initWithJSON:dict]];
    }
    
    return fileVersions;
}

#pragma mark - Superclass overidden methods

- (NSString *)itemIDForSharedLink
{
    return self.fileID;
}

- (BOXAPIItemType *)itemTypeForSharedLink
{
    return BOXAPIItemTypeFile;
}

@end
