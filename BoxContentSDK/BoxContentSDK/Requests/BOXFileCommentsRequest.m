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
    
    BOXAPIJSONOperation *JSONOperation = [self JSONOperationWithURL:URL
                                                         HTTPMethod:BOXAPIHTTPMethodGET
                                              queryStringParameters:nil
                                                     bodyDictionary:nil
                                                   JSONSuccessBlock:nil
                                                       failureBlock:nil];
    [self addSharedLinkHeaderToRequest:JSONOperation.APIRequest];

    return JSONOperation;
}

- (void)performRequestWithCompletion:(BOXObjectsArrayCompletionBlock)completionBlock
{
    BOOL isMainThread = [NSThread isMainThread];
    BOXAPIJSONOperation *commentsOperation = (BOXAPIJSONOperation *)self.operation;
    
    if (completionBlock) {
        commentsOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock([self commentsFromJSONDictionary:JSONDictionary] ,nil);
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
