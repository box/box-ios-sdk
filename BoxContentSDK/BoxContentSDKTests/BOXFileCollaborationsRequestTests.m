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

@implementation BOXFileCollaborationsRequestTests

- (void)test_request_has_expected_URLRequest
{
    NSString *fileID = @"123";
    
    BOXFileCollaborationsRequest *request = [[BOXFileCollaborationsRequest alloc] initWithFileID:fileID];
    NSURLRequest *URLRequest = request.urlRequest;
    
    // URL assertions
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/files/%@/collaborations?limit=100", [BOXContentClient APIBaseURL], fileID]];
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"GET", URLRequest.HTTPMethod);
}

@end
