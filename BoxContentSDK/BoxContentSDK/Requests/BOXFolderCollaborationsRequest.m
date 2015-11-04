//
//  BOXFolderCollaborationsRequest.m
//  BoxContentSDK
//

#import "BOXFolderCollaborationsRequest.h"

#import "BOXCollaboration.h"

@interface BOXFolderCollaborationsRequest ()

@property (nonatomic, readwrite, strong) NSString *folderID;

@end

@implementation BOXFolderCollaborationsRequest

- (instancetype)initWithFolderID:(NSString *)folderID
{
    self = [super init];
    if (self != nil) {
        _folderID = folderID;
    }
    
    return self;
}

- (BOXAPIOperation *)createOperation
{
    NSURL *URL = [self URLWithResource:BOXAPIResourceFolders
                                    ID:self.folderID
                           subresource:BOXAPIResourceCollaborations
                                 subID:nil];
    
    BOXAPIJSONOperation *JSONoperation = [self JSONOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodGET
                                              queryStringParameters:nil
                                                     bodyDictionary:nil
                                                   JSONSuccessBlock:nil
                                                       failureBlock:nil];
    return JSONoperation;
}

- (void)performRequestWithCompletion:(BOXCollaborationArrayCompletionBlock)completionBlock
{
    if (completionBlock) {
        BOOL isMainThread = [NSThread isMainThread];
        BOXAPIJSONOperation *folderOperation = (BOXAPIJSONOperation *)self.operation;

        folderOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            NSArray *collaborationDictionaries = [JSONDictionary objectForKey:BOXAPICollectionKeyEntries];
            NSMutableArray *collaborations = [NSMutableArray arrayWithCapacity:collaborationDictionaries.count];
            for (NSDictionary *collaborationDictionary in collaborationDictionaries) {
                [collaborations addObject:[[BOXCollaboration alloc] initWithJSON:collaborationDictionary]];
            }

            if ([self.cacheClient respondsToSelector:@selector(cacheFolderCollaborationsRequest:withCollaborations:error:)]) {
                [self.cacheClient cacheFolderCollaborationsRequest:self
                                                withCollaborations:collaborations
                                                             error:nil];
            }

            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(collaborations, nil);
            } onMainThread:isMainThread];
        };
        folderOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {

            if ([self.cacheClient respondsToSelector:@selector(cacheFolderCollaborationsRequest:withCollaborations:error:)]) {
                [self.cacheClient cacheFolderCollaborationsRequest:self
                                                withCollaborations:nil
                                                             error:error];
            }

            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil, error);
            } onMainThread:isMainThread];
        };
        [self performRequest];
    }
}

- (void)performRequestWithCached:(BOXCollaborationArrayCompletionBlock)cacheBlock
                       refreshed:(BOXCollaborationArrayCompletionBlock)refreshBlock
{
    if (cacheBlock) {
        if ([self.cacheClient respondsToSelector:@selector(retrieveCacheForFolderCollaborationsRequest:completion:)]) {
            [self.cacheClient retrieveCacheForFolderCollaborationsRequest:self completion:cacheBlock];
        } else {
            cacheBlock(nil, nil);
        }
    }

    [self performRequestWithCompletion:refreshBlock];
}

@end
