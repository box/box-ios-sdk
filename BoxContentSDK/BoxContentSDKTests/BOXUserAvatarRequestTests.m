//
//  BOXUserAvatarRequestTests.m
//  BoxContentSDK
//
//  Created on 10/25/2016.
//  Copyright (c) 2016 Box. All rights reserved.
//

#import "BOXRequestTestCase.h"
#import "BOXContentClient.h"
#import "BOXUserAvatarRequest.h"
#import "BOXRequest_Private.h"


@interface BOXUserAvatarRequestTests : BOXRequestTestCase
@end

@implementation BOXUserAvatarRequestTests

#pragma mark - URL

- (void)test_that_avatar_request_has_expected_URLRequest
{
    NSString *userID = @"123";
    BOXUserAvatarRequest *request = [[BOXUserAvatarRequest alloc] initWithUserID:userID];
    NSURLRequest *URLRequest = request.urlRequest;
    
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/%@/avatar", [BOXContentClient APIBaseURL], userID]];
    
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"GET", URLRequest.HTTPMethod);
}

- (void)test_that_avatar_request_has_expected_URLRequest_with_specified_type_small
{
    NSString *userID = @"123";
    BOXUserAvatarRequest *request = [[BOXUserAvatarRequest alloc] initWithUserID:userID];
    request.avatarType = BOXAvatarTypeSmall;
    NSURLRequest *URLRequest = request.urlRequest;
    
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/%@/avatar?pic_type=small", [BOXContentClient APIBaseURL], userID]];
    
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"GET", URLRequest.HTTPMethod);
}

- (void)test_that_avatar_request_has_expected_URLRequest_with_specified_type_large
{
    NSString *userID = @"123";
    BOXUserAvatarRequest *request = [[BOXUserAvatarRequest alloc] initWithUserID:userID];
    request.avatarType = BOXAvatarTypeLarge;
    NSURLRequest *URLRequest = request.urlRequest;
    
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/%@/avatar?pic_type=large", [BOXContentClient APIBaseURL], userID]];
    
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"GET", URLRequest.HTTPMethod);
}

- (void)test_that_avatar_request_has_expected_URLRequest_with_specified_preview
{
    NSString *userID = @"123";
    BOXUserAvatarRequest *request = [[BOXUserAvatarRequest alloc] initWithUserID:userID];
    request.avatarType = BOXAvatarTypePreview;
    NSURLRequest *URLRequest = request.urlRequest;
    
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/%@/avatar?pic_type=preview", [BOXContentClient APIBaseURL], userID]];
    
    XCTAssertEqualObjects(expectedURL, URLRequest.URL);
    XCTAssertEqualObjects(@"GET", URLRequest.HTTPMethod);
}

#pragma mark - Download data

- (void)test_that_avatar_request_returns_expected_avatar
{
    BOXUserAvatarRequest *request = [[BOXUserAvatarRequest alloc] initWithUserID:@"123"];
    
    UIImage *cannedResponseImage = [self blankImageWithSize:CGSizeMake(22, 22) color:[UIColor greenColor]];
    NSData *cannedResponseData =  UIImagePNGRepresentation(cannedResponseImage);
    NSHTTPURLResponse *URLResponse = [self cannedURLResponseWithStatusCode:200 responseData:cannedResponseData];
    [self setCannedURLResponse:URLResponse cannedResponseData:cannedResponseData forRequest:request];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"expectation"];
    [request performRequestWithProgress:nil completion:^(UIImage *image, NSError *error) {
        XCTAssertNil(error);
        // Difficult to test image equality but a size check is sufficient, and important to ensure
        // we respected screen scale (e.g. retina vs non-retina) when decoding.
        XCTAssertEqual(cannedResponseImage.size.width, image.size.width);
        XCTAssertEqual(cannedResponseImage.size.height, image.size.height);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

- (void)test_that_operation_is_marked_as_small_download
{
    BOXUserAvatarRequest *request = [[BOXUserAvatarRequest alloc] initWithUserID:@"123"];
    BOXAPIOperation *operation = [request operation];
    XCTAssert([operation isKindOfClass:[BOXAPIDataOperation class]]);
    BOXAPIDataOperation *dataOperation = (BOXAPIDataOperation *)operation;
    XCTAssert(dataOperation.isSmallDownloadOperation);
}

#pragma mark - Private helper

- (UIImage *)blankImageWithSize:(CGSize)size color:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    [color setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
