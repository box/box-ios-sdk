//
//  BOXBookmarkCommentsRequest.m
//  BoxContentSDK
//

#import "BOXRequest_Private.h"
#import "BOXBookmarkCommentsRequest.h"

#import "BOXAPIJSONOperation.h"
#import "BOXComment.h"

@interface BOXBookmarkCommentsRequest ()

@property (nonatomic, readwrite, strong) NSString *bookmarkID;

@end

@implementation BOXBookmarkCommentsRequest 

- (instancetype)initWithBookmarkID:(NSString *)bookmarkID
{
    if (self = [super init]) {
        _bookmarkID = bookmarkID;
    }
    
    return self;
}

- (BOXAPIOperation *)createOperation
{
    BOXAPIOperation *operation = nil;
    
    NSURL *url = [self URLWithResource:BOXAPIResourceBookmarks
                                    ID:self.bookmarkID
                           subresource:BOXAPISubresourceComments
                                 subID:nil];
    
    operation = [self JSONOperationWithURL:url 
                                HTTPMethod:BOXAPIHTTPMethodGET 
                     queryStringParameters:nil 
                            bodyDictionary:nil 
                          JSONSuccessBlock:nil 
                              failureBlock:nil];
    
    return operation;
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
    NSArray *commentsDicts = JSONDictionary[@"entries"];
    NSMutableArray *comments = [NSMutableArray arrayWithCapacity:commentsDicts.count];
    
    for (NSDictionary *dict in commentsDicts) {
        [comments addObject:[[BOXComment alloc] initWithJSON:dict]];
    }
    
    return comments;
}

#pragma mark - Superclass overidden methods

- (NSString *)itemIDForSharedLink
{
    return self.bookmarkID;
}

- (BOXAPIItemType *)itemTypeForSharedLink
{
    return BOXAPIItemTypeWebLink;
}

@end
