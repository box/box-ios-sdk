//
//  BOXEventAdminLogsRequestTests.m
//  BoxContentSDK
//
//  Created by Clement Rousselle on 12/18/14.
//  Copyright (c) 2014 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXContentClient.h"
#import "BOXEventsAdminLogsRequest.h"
#import "NSURL+BOXURLHelper.h"
#import "BOXContentSDKConstants.h"

@interface BOXEventAdminLogsRequestTests : BOXRequestTestCase

@end


@implementation BOXEventAdminLogsRequestTests

- (void)test_url_request_is_correct_with_all_values
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [BOXContentClient APIBaseURL], BOXAPIResourceEvents]];
    BOXEventsAdminLogsRequest *request = [[BOXEventsAdminLogsRequest alloc] init];
    request.limit = 200;
    NSString *streamPosition = @"DFLSDFKGJFDLGKJFDSGF";
    request.streamPosition = streamPosition;
    request.eventType = BOXAPIEnterpriseEventTypeCopy;
    NSDate *afterDate = [NSDate date];
    request.createdAfterDate = afterDate;
    NSDate *beforeDate = [NSDate date];
    request.createdBeforeDate = beforeDate;
    
    NSMutableDictionary *expectedParameters = [NSMutableDictionary dictionary];
    [expectedParameters setObject:BOXAPIEventStreamTypeAdminLogs forKey:BOXAPIParameterKeyStreamType];
    [expectedParameters setObject:@"200" forKey:BOXAPIParameterKeyLimit];
    [expectedParameters setObject:streamPosition forKey:BOXAPIParameterKeyStreamPosition];
    [expectedParameters setObject:BOXAPIEnterpriseEventTypeCopy forKey:BOXAPIParameterKeyEventType];
    [expectedParameters setObject:[afterDate box_ISO8601String] forKey:BOXAPIParameterKeyCreatedAfter];
    [expectedParameters setObject:[beforeDate box_ISO8601String] forKey:BOXAPIParameterKeyCreatedBefore];
    
    NSString *actualURLWithoutQueryString = [NSString stringWithFormat:@"%@://%@%@", request.urlRequest.URL.scheme, request.urlRequest.URL.host, request.urlRequest.URL.path];
    
    XCTAssertEqualObjects(BOXAPIHTTPMethodGET, request.urlRequest.HTTPMethod);
    XCTAssertEqualObjects([url absoluteString], actualURLWithoutQueryString);
    
    NSDictionary *parameters = [request.urlRequest.URL box_queryDictionary];
    
    XCTAssertTrue([expectedParameters isEqualToDictionary:parameters]);
}


@end
