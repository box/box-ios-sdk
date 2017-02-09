//
//  BOXEventsAdminLogsRequest.m
//  BoxContentSDK
//

#import "BOXEventsAdminLogsRequest.h"

@implementation BOXEventsAdminLogsRequest

@synthesize streamType;

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
    
    parameters[BOXAPIParameterKeyStreamType] = BOXAPIEventStreamTypeAdminLogs;
    
    if (self.createdAfterDate) {
        parameters[BOXAPIParameterKeyCreatedAfter] = [self.createdAfterDate box_ISO8601String];
    }
    
    if (self.createdBeforeDate) {
        parameters[BOXAPIParameterKeyCreatedBefore] = [self.createdBeforeDate box_ISO8601String];
    }
    
    if (self.eventType) {
        parameters[BOXAPIParameterKeyEventType] = self.eventType;
    }
    
    operation = [self JSONOperationWithURL:url HTTPMethod:BOXAPIHTTPMethodGET 
                     queryStringParameters:parameters 
                            bodyDictionary:nil 
                          JSONSuccessBlock:nil 
                              failureBlock:nil];
    
    return operation;
}

@end
