//
//  BOXFileCollaborationsRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXFileCollaborationsRequest.h"

#import "BOXCollaboration.h"
#import "BOXDispatchHelper.h"

@interface BOXFileCollaborationsRequest ()

@property (nonatomic, readwrite, strong) NSString *fileID;

@end

@implementation BOXFileCollaborationsRequest

- (instancetype)initWithFileID:(NSString *)fileID
{
    self = [super init];
    if (self != nil) {
        _fileID = fileID;
    }
    
    return self;
}

- (BOXAPIOperation *)createOperation
{
    NSURL *URL = [self URLWithResource:BOXAPIResourceFiles
                                    ID:self.fileID
                           subresource:BOXAPIResourceCollaborations
                                 subID:nil];
    
    NSMutableDictionary *queryParameters = [NSMutableDictionary dictionary];
    
    if (self.limit > 0) {
        queryParameters[BOXAPIParameterKeyLimit] = @(self.limit);
    } else {
        queryParameters[BOXAPIParameterKeyLimit] = @(100);
    }
    
    if (self.nextMarker != nil) {
        queryParameters[BOXAPIParameterKeyMarker] = self.nextMarker;
    }
    
    BOXAPIJSONOperation *JSONoperation = [self JSONOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodGET
                                              queryStringParameters:queryParameters
                                                     bodyDictionary:nil
                                                   JSONSuccessBlock:nil
                                                       failureBlock:nil];
    return JSONoperation;
}

- (void)performRequestWithCompletion:(BOXFileCollaborationArrayCompletionBlock)completionBlock
{
    if (completionBlock) {
        BOOL isMainThread = [NSThread isMainThread];
        BOXAPIJSONOperation *fileOperation = (BOXAPIJSONOperation *)self.operation;
        
        fileOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            NSArray *collaborationDictionaries = [JSONDictionary objectForKey:BOXAPICollectionKeyEntries];
            NSString *nextMarker = JSONDictionary[BOXAPIParameterKeyNextMarker];
            NSMutableArray *collaborations = [NSMutableArray arrayWithCapacity:collaborationDictionaries.count];
            
            for (NSDictionary *collaborationDictionary in collaborationDictionaries) @autoreleasepool {
                [collaborations addObject:[[BOXCollaboration alloc] initWithJSON:collaborationDictionary]];
            }
            
            if ([self.cacheClient respondsToSelector:@selector(cacheFileCollaborationsRequest:withCollaborations:nextMarker:error:)]) {
                [self.cacheClient cacheFileCollaborationsRequest:self
                                              withCollaborations:collaborations
                                                      nextMarker:nextMarker
                                                           error:nil];
            }
            
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(collaborations, nextMarker, nil);
            } onMainThread:isMainThread];
        };
        fileOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
            
            if ([self.cacheClient respondsToSelector:@selector(cacheFileCollaborationsRequest:withCollaborations:nextMarker:error:)]) {
                [self.cacheClient cacheFileCollaborationsRequest:self
                                              withCollaborations:nil
                                                      nextMarker:nil
                                                           error:error];
            }
            
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil, nil, error);
            } onMainThread:isMainThread];
        };
        
        [self performRequest];
    }
}

- (void)performRequestWithCached:(BOXFileCollaborationArrayCompletionBlock)cacheBlock
                       refreshed:(BOXFileCollaborationArrayCompletionBlock)refreshBlock
{
    if (cacheBlock) {
        if ([self.cacheClient respondsToSelector:@selector(retrieveCacheForFileCollaborationsRequest:completion:)]) {
            [self.cacheClient retrieveCacheForFileCollaborationsRequest:self completion:cacheBlock];
        } else {
            cacheBlock(nil, nil, nil);
        }
    }
    
    [self performRequestWithCompletion:refreshBlock];
}

@end
