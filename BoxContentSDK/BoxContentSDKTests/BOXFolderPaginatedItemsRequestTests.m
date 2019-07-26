//
//  BOXFolderPaginatedItemsRequest.m
//  BoxContentSDK
//

#import "BOXRequestTestCase.h"
#import "BOXContentClient.h"
#import "BOXBookmark.h"
#import "BOXFile.h"
#import "BOXFolder.h"
#import "BOXFolderPaginatedItemsRequest.h"
#import "BOXRequest_Private.h"
#import "NSURL+BOXURLHelper.h"
#import "BOXContentSDKTestsConstants.h"

@interface BOXFolderPaginatedItemsRequestTests : BOXRequestTestCase

@end

@implementation BOXFolderPaginatedItemsRequestTests

#pragma mark - URLRequest

- (void)test_that_request_with_metadata_templateKey_and_scope_creates_query_parameters_with_metadata_info
{
    BOXFolderPaginatedItemsRequest *request = [[BOXFolderPaginatedItemsRequest alloc] initWithFolderID:@"123" metadataTemplateKey:@"test" metadataScope:@"scope" inRange:NSMakeRange(0,5)];
    request.requestAllItemFields = YES;

    BOXAPIOperation *op = [request createOperation];
    NSDictionary *queryDict = op.queryStringParameters;
    NSString *fieldString = [queryDict objectForKey:BOXAPIParameterKeyFields];
    
    XCTAssertTrue([fieldString isEqualToString:expectedItemRequestFieldsStringWithMetadata]);
    
}

- (void)test_that_request_without_metadata_templateKey_and_scope_creates_correct_query_parameters
{
    BOXFolderPaginatedItemsRequest *request = [[BOXFolderPaginatedItemsRequest alloc] initWithFolderID:@"123" inRange:NSMakeRange(0,5)];
    request.requestAllItemFields = YES;
    BOXAPIOperation *op = [request createOperation];
    NSDictionary *queryDict = op.queryStringParameters;
    NSString *fieldString = [queryDict objectForKey:BOXAPIParameterKeyFields];
    
    XCTAssertTrue([fieldString isEqualToString:expectedItemRequestFieldsStringWithoutMetadata]);
    
}

- (void)test_that_basic_request_has_expected_URLRequest
{
    NSString *folderID = @"123";
    BOXFolderPaginatedItemsRequest *request = [[BOXFolderPaginatedItemsRequest alloc] initWithFolderID:folderID inRange:NSMakeRange(2, 5)];
    request.requestAllItemFields = YES;
    NSURLRequest *URLRequest = request.urlRequest;

    NSString *expectedURL = [NSString stringWithFormat:@"%@/folders/%@/items", [BOXContentClient APIBaseURL], folderID];
    NSString *requestURL = [NSString stringWithFormat:@"%@://%@%@", URLRequest.URL.scheme, URLRequest.URL.host, URLRequest.URL.path];

    XCTAssertEqualObjects(expectedURL, requestURL);
    XCTAssertEqualObjects(@"GET", URLRequest.HTTPMethod);

    NSDictionary *requestURLParameters = [URLRequest.URL box_queryDictionary];
    NSString *expectedFieldsString = [[[BOXRequest alloc] init] fullItemFieldsParameterString];

    XCTAssertEqualObjects([requestURLParameters[BOXAPIParameterKeyFields] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], expectedFieldsString);
    XCTAssertEqualObjects(requestURLParameters[BOXAPIParameterKeyLimit], @"5");
    XCTAssertEqualObjects(requestURLParameters[BOXAPIParameterKeyOffset], @"2");
    
    // verify offset can be set to 0
    request = [[BOXFolderPaginatedItemsRequest alloc] initWithFolderID:folderID inRange:NSMakeRange(0, 1000)];
    URLRequest = request.urlRequest;
    requestURLParameters = [URLRequest.URL box_queryDictionary];
    XCTAssertEqualObjects(requestURLParameters[BOXAPIParameterKeyLimit], @"1000");
    XCTAssertEqualObjects(requestURLParameters[BOXAPIParameterKeyOffset], @"0");
}

- (void)test_shared_link_properties
{
    NSString *folderID = @"123";
    BOXFolderPaginatedItemsRequest *request = [[BOXFolderPaginatedItemsRequest alloc] initWithFolderID:folderID inRange:NSMakeRange(2, 5)];
    
    XCTAssertEqualObjects([request itemIDForSharedLink], folderID);
    XCTAssertEqualObjects([request itemTypeForSharedLink], BOXAPIItemTypeFolder);    
}

#pragma mark - Perform Request

- (void)test_that_expected_items_are_returned_for_folder_paginated_items_request
{
    BOXFolderPaginatedItemsRequest *request = [[BOXFolderPaginatedItemsRequest alloc] initWithFolderID:@"123" inRange:NSMakeRange(0, 5)];

    NSData *cannedData = [self cannedResponseDataWithName:@"get_items"];
    
    NSArray *expectedItems = [self itemsFromResponseData:cannedData];
    
    NSHTTPURLResponse *response = [self cannedURLResponseWithStatusCode:200 responseData:cannedData];

    [self setCannedURLResponse:response cannedResponseData:cannedData forRequest:request];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [request performRequestWithCompletion:^(NSArray *objects, NSUInteger totalCount, NSRange range, NSError *error) {
        XCTAssertNil(error);
        XCTAssertEqual(objects.count, expectedItems.count);
        XCTAssertEqual(totalCount, 24);
        XCTAssertEqual(range.location, 0);
        XCTAssertEqual(range.length, 5);
        for (NSUInteger i = 0; i < objects.count ; i++) {
            [self assertModel:objects[i] isEquivalentTo:expectedItems[i]];
        }

        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

@end
