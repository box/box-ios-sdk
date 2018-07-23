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

@interface BOXFolderPaginatedItemsRequestTests : BOXRequestTestCase

@end

@implementation BOXFolderPaginatedItemsRequestTests

NSString *const expectedFieldString = @"type,id,sequence_id,etag,name,description,size,path_collection,created_at,modified_at,trashed_at,purged_at,content_created_at,content_modified_at,created_by,modified_by,owned_by,shared_link,parent,item_status,permissions,lock,extension,is_package,allowed_shared_link_access_levels,collections,collection_memberships,folder_upload_email,sync_state,has_collaborations,is_externally_owned,can_non_owners_invite,allowed_invitee_roles,sha1,version_number,comment_count,url";

#pragma mark - URLRequest

- (void)test_that_request_with_metadata_templateKey_and_scope_creates_query_parameters_with_metadata_info
{
    BOXFolderPaginatedItemsRequest *request = [[BOXFolderPaginatedItemsRequest alloc] initWithFolderID:@"123" metadataTemplateKey:@"test" metadataScope:@"scope" inRange:NSMakeRange(0,5)];
    request.requestAllItemFields = YES;
    
    NSString *expectedFieldStringWithMetadata = [expectedFieldString stringByAppendingString:@",metadata.scope.test"];
    BOXAPIOperation *op = [request createOperation];
    NSDictionary *queryDict = op.queryStringParameters;
    NSString *fieldString = [queryDict objectForKey:BOXAPIParameterKeyFields];
    
    XCTAssertTrue([fieldString isEqualToString:expectedFieldStringWithMetadata]);
    
}

- (void)test_that_request_without_metadata_templateKey_and_scope_creates_correct_query_parameters
{
    BOXFolderPaginatedItemsRequest *request = [[BOXFolderPaginatedItemsRequest alloc] initWithFolderID:@"123" inRange:NSMakeRange(0,5)];
    request.requestAllItemFields = YES;
    BOXAPIOperation *op = [request createOperation];
    NSDictionary *queryDict = op.queryStringParameters;
    NSString *fieldString = [queryDict objectForKey:BOXAPIParameterKeyFields];
    
    XCTAssertTrue([fieldString isEqualToString:expectedFieldString]);
    
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
