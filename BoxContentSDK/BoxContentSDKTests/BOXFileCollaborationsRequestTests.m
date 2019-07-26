//
//  BOXFileCollaborationsRequestTests.m
//  BoxContentSDK
//
//

#import "BOXRequestTestCase.h"
#import "BOXContentClient.h"

@import BoxContentSDK.BOXFileCollaborationsRequest;

@interface BOXFileCollaborationsRequestTests : BOXRequestTestCase

@end

NSString *const someFileID = @"123";

@implementation BOXFileCollaborationsRequestTests

- (void)assert_request_url:(BOXFileCollaborationsRequest *)request box_id:(NSString *)box_id
{
    [self assert_request_url:request box_id:box_id limit:100 next_marker:nil];
}

- (void)assert_request_url:(BOXFileCollaborationsRequest *)request box_id:(NSString *)box_id limit:(int)limit
{
    [self assert_request_url:request box_id:box_id limit:limit next_marker:nil];
}

- (void)assert_request_url:(BOXFileCollaborationsRequest *)request box_id:(NSString *)box_id next_marker:(NSString *)marker
{
    [self assert_request_url:request box_id:box_id limit:100 next_marker:marker];
}

- (void)assert_request_url:(BOXFileCollaborationsRequest *)request box_id:(NSString *)box_id limit:(int)limit next_marker:(NSString *)marker
{
    NSURLRequest *URLRequest = request.urlRequest;

    // URL assertions
    NSMutableString *rawURL = [NSMutableString stringWithFormat:@"%@/files/%@/collaborations?limit=%d", [BOXContentClient APIBaseURL], box_id, limit];
    
    if (marker) {
        [rawURL appendFormat:@"&marker=%@", marker];
    }
    
    NSURL *expectedURL = [NSURL URLWithString:rawURL];
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"GET", URLRequest.HTTPMethod);
}

- (void)test_request_has_expected_URLRequest
{
    // code under test
    BOXFileCollaborationsRequest *request = [[BOXFileCollaborationsRequest alloc] initWithFileID:someFileID];
    
    // validate
    [self assert_request_url:request box_id:someFileID];
}

- (void)test_request_with_limit_has_expected_URLRequest
{
    // code under test
    BOXFileCollaborationsRequest *request = [[BOXFileCollaborationsRequest alloc] initWithFileID:someFileID];
    request.limit = 53;
    
    // validate
    [self assert_request_url:request box_id:someFileID limit:53];
}

- (void)test_request_with_next_marker_has_expected_URLRequest
{
    // code under test
    BOXFileCollaborationsRequest *request = [[BOXFileCollaborationsRequest alloc] initWithFileID:someFileID];
    request.nextMarker = @"some_marker";

    // validate
    [self assert_request_url:request box_id:someFileID next_marker:@"some_marker"];
}

- (void)test_request_with_limit_and_next_marker_has_expected_URLRequest
{
    // code under test
    BOXFileCollaborationsRequest *request = [[BOXFileCollaborationsRequest alloc] initWithFileID:someFileID];
    request.nextMarker = @"another_marker";
    request.limit = 1000;
    
    // validate
    [self assert_request_url:request box_id:someFileID limit:1000 next_marker:@"another_marker"];
}


@end
