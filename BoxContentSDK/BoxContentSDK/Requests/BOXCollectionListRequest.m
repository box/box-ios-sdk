//
//  BOXCollectionListRequest.m
//  BoxContentSDK
//

#import "BOXCollectionListRequest.h"

#import "BOXCollection.h"

@implementation BOXCollectionListRequest

- (BOXAPIOperation *)createOperation
{
    BOXAPIOperation *operation = nil;
    
    NSURL *url = [self URLWithResource:BOXAPIResourceCollections
                                    ID:nil
                           subresource:nil
                                 subID:nil];
    
    operation = [self JSONOperationWithURL:url 
                                HTTPMethod:BOXAPIHTTPMethodGET
                     queryStringParameters:nil 
                            bodyDictionary:nil 
                          JSONSuccessBlock:nil 
                              failureBlock:nil];
    
    return operation;
}

- (void)performRequestWithCompletion:(BOXCollectionArrayBlock)completionBlock
{        
    BOOL isMainThread = [NSThread isMainThread];

    BOXAPIJSONOperation *collectionListOperation = (BOXAPIJSONOperation *)self.operation;

    if (completionBlock) {
        collectionListOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            [BOXDispatchHelper callCompletionBlock:^{
                NSArray *collectionsJSON = JSONDictionary[BOXAPICollectionKeyEntries];
                NSMutableArray *collections = [NSMutableArray arrayWithCapacity:collectionsJSON.count];
                
                for (NSDictionary *dict in collectionsJSON) {
                    [collections addObject:[[BOXCollection alloc] initWithJSON:dict]];
                }
                completionBlock(collections, nil);
            } onMainThread:isMainThread];
        };
        collectionListOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil,error);
            } onMainThread:isMainThread];
        };
    }
    
    [self performRequest];
}



@end
