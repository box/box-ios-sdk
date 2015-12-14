//
//  BOXEventsRequest.m
//  BoxContentSDK
//

#import "BOXEventsRequest.h"

#import "BOXEvent.h"

@implementation BOXEventsRequest

- (instancetype)init
{
    if (self = [super init]) {
        _streamPosition = BOXAPIEventStreamPositionDefault;
        _streamType = BOXEventsStreamTypeAll;
    }
    return self;
}

- (BOXAPIOperation *)createOperation
{
    BOXAPIOperation *operation = nil;
    
    NSURL *url = [self URLWithResource:BOXAPIResourceEvents ID:nil subresource:nil subID:nil];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (self.limit > 0) {
        parameters[BOXAPIParameterKeyLimit] = @(self.limit);
    }
    
    if (![self.streamPosition isEqualToString:BOXAPIEventStreamPositionDefault]) {
        parameters[BOXAPIParameterKeyStreamPosition] = self.streamPosition;
    }
    
    if (self.streamType != BOXEventsStreamTypeAll) {
        parameters[BOXAPIParameterKeyStreamType] = [self stringFromEventsStreamType:self.streamType];
    }
    
    operation = [self JSONOperationWithURL:url HTTPMethod:BOXAPIHTTPMethodGET 
                     queryStringParameters:parameters 
                            bodyDictionary:nil 
                          JSONSuccessBlock:nil 
                              failureBlock:nil];
    
    return operation;
}

- (void)performRequestWithCompletion:(BOXEventsBlock)completionBlock
{
    if (completionBlock) {
        BOOL isMainThread = [NSThread isMainThread];
        BOXAPIJSONOperation *eventsRequestOperation = (BOXAPIJSONOperation *)self.operation;

        eventsRequestOperation.success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSONDictionary) {
            [BOXDispatchHelper callCompletionBlock:^{

                NSArray *eventsJSON = JSONDictionary[BOXAPICollectionKeyEntries];
                NSMutableArray *events = [NSMutableArray arrayWithCapacity:eventsJSON.count];
                
                for (NSDictionary *dict in eventsJSON) {
                    [events addObject:[[BOXEvent alloc] initWithJSON:dict]];
                }
                NSString *nextStreamPosition = [NSString stringWithFormat:@"%@", JSONDictionary[BOXAPICollectionKeyNextStreamPosition]];
                
                completionBlock(events, nextStreamPosition, nil);
            } onMainThread:isMainThread];
        };
        eventsRequestOperation.failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
            [BOXDispatchHelper callCompletionBlock:^{
                completionBlock(nil, nil, error);
            } onMainThread:isMainThread];
        };
        [self performRequest];
    }
}

#pragma mark - Private Helpers

- (NSString *)stringFromEventsStreamType:(BOXEventsStreamType)type
{
    NSString *result = nil;

    switch (type) {
        case BOXEventsStreamTypeAll:
            result = BOXAPIEventStreamTypeAll;
            break;
        case BOXEventsStreamTypeChanges:
            result = BOXAPIEventStreamTypeChanges;
            break;
        case BOXEventsStreamTypeSync:
            result = BOXAPIEventStreamTypeSync;
            break;
        default:
            break;
    }
    return result;
}

@end
