//
//  BOXFileCommentsRequest.m
//  BoxContentSDK
//

#import "BOXFileCommentsRequest.h"

#import "BOXAPIJSONOperation.h"
#import "BOXComment.h"
#import "BOXRequest_Private.h"

@interface BOXFileCommentsRequest ()

@property (nonatomic, readwrite, strong) NSString *fileID;

- (NSArray *)commentsFromJSONDictionary:(NSDictionary *)JSONDictionary;

@end

@implementation BOXFileCommentsRequest

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
                           subresource:BOXAPISubresourceComments
                                 subID:nil];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (self.requestAllItemFields) {
        parameters[BOXAPIParameterKeyFields] = [self fullCommentFieldsParameterString];
    }
    
    BOXAPIJSONOperation *JSONOperation = [self JSONOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodGET
                                              queryStringParameters:parameters
                                                     bodyDictionary:nil
                                                   JSONSuccessBlock:nil
                                                       failureBlock:nil];
    [self addSharedLinkHeaderToRequest:JSONOperation.APIRequest];

    return JSONOperation;
}

- (void)performRequestWithCompletion:(BOXObjectsArrayCompletionBlock)completionBlock
{
    if (completionBlock) {
        BOOL isMainThread = [NSThread isMainThread];
        BOXAPIJSONOperation *commentsOperation = (BOXAPIJSONOperation *)self.operation;

        commentsOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            NSArray *comments = [self commentsFromJSONDictionary:JSONDictionary];

            if ([self.cacheClient respondsToSelector:@selector(cacheFileCommentsRequest:withComments:error:)]) {
                [self.cacheClient cacheFileCommentsRequest:self
                                              withComments:comments
                                                     error:nil];
            }

            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(comments ,nil);
            } onMainThread:isMainThread];
        };

        commentsOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {

            if ([self.cacheClient respondsToSelector:@selector(cacheFileCommentsRequest:withComments:error:)]) {
                [self.cacheClient cacheFileCommentsRequest:self
                                              withComments:nil
                                                     error:error];
            }

            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil,error);
            } onMainThread:isMainThread];
        };
        [self performRequest];
    }
}

- (void)performRequestWithCached:(BOXObjectsArrayCompletionBlock)cacheBlock
                       refreshed:(BOXObjectsArrayCompletionBlock)refreshBlock
{
    if (cacheBlock) {
        if ([self.cacheClient respondsToSelector:@selector(retrieveCacheForFileCommentsRequest:completion:)]) {
            [self.cacheClient retrieveCacheForFileCommentsRequest:self
                                                       completion:cacheBlock];
        } else {
            cacheBlock(nil, nil);
        }
    }

    [self performRequestWithCompletion:refreshBlock];
}

#pragma mark - Private Helpers

- (NSArray *)commentsFromJSONDictionary:(NSDictionary *)JSONDictionary
{
    NSArray *commentsDicts = [JSONDictionary objectForKey:@"entries"];
    NSMutableArray *comments = [NSMutableArray arrayWithCapacity:commentsDicts.count];
    
    for (NSDictionary *dict in commentsDicts) {
        [comments addObject:[[BOXComment alloc] initWithJSON:dict]];
    }
    
    return comments;
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
