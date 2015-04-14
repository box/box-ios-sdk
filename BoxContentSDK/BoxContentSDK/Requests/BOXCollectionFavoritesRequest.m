//
//  BOXCollectionFavoritesRequest.m
//  BoxContentSDK
//

#import "BOXCollectionFavoritesRequest.h"

#import "BOXCollection.h"

@implementation BOXCollectionFavoritesRequest 

- (void)performRequestWithCompletion:(BOXCollectionBlock)completionBlock
{
    BOOL isMainThread = [NSThread isMainThread];
    
    BOXAPIJSONOperation *collectionListOperation = (BOXAPIJSONOperation *)self.operation;

    if (completionBlock) {
        collectionListOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            [BOXDispatchHelper callCompletionBlock:^{
                NSArray *collectionsJSON = JSONDictionary[BOXAPICollectionKeyEntries];
                
                BOXCollection *favoritesCollection = nil;

                for (NSDictionary *dict in collectionsJSON) {

                    if([dict[BOXAPIObjectKeyCollectionType] isEqualToString:BOXAPIFavoritesCollectionType]) {
                        favoritesCollection = [[BOXCollection alloc] initWithJSON:dict];
                    }
                }
                completionBlock(favoritesCollection, nil);
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
